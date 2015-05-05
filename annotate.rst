Annotation of denovo transcriptome
==================================

Identify the Gene/Transcript relationships:
--------------------------------------------
we can generate this file like so::

  cd /mnt/work
  ~/trinity/util/support_scripts/get_Trinity_gene_to_trans_map.pl trinity_out_dir/Trinity.fasta >  Trinity.fasta.gene_trans_map

Let's have a look on the map::

  less Trinity.fasta.gene_trans_map

Components, genes and isoforms:

* The different (i's) that correspond to the same (g) represent isoforms
* The different (g's) could represent different genes (or parts of genes)
* The component (TR|c) often contain related genes (paralogs or gene fragments).
  
  Check the `Trinityseq forum <https://groups.google.com/forum/#!topic/trinityrnaseq-users/1XTZ5S0I8J0>`__ for more details   

Generate the longest-ORF peptide candidates from the Trinity Assembly:
----------------------------------------------------------------------
We need to install Transdecoder to do this job::

   cd
   sudo cpan URI::Escape

.. note:: type yes for all interactive questions

::

   curl -L https://github.com/TransDecoder/TransDecoder/archive/2.0.1.tar.gz > transdecoder.tar.gz
   tar xzf transdecoder.tar.gz
   mv TransDecoder* TransDecoder
   cd TransDecoder
   make

Now we can run the Transdecoder software to identify the longest-ORF peptide::

   cd /mnt/work
   ~/TransDecoder/TransDecoder.LongOrfs -t trinity_out_dir/Trinity.fasta

Check the Transdecoder output::

  less Trinity.fasta.transdecoder_dir/longest_orfs.pep
  
   
Capturing BLAST Homologies
--------------------------
Install BLAST+ (http://www.ncbi.nlm.nih.gov/books/NBK52640/)::

   sudo apt-get install -y ncbi-blast+

.. wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/LATEST/ncbi-blast-*+-x64-linux.tar.gz
   tar zxvpf ncbi-blast*.tar.gz
   rm ncbi-blast*.tar.gz
   mv ncbi-blast* blast+
   export PATH=”$PATH:$HOME/blast+/bin”

Get the required sequence databases and prepare local blast databases

a) SwissProt database: The UniProt Knowledgebase which include the Manually annotated proteins::

    cd /mnt/work
    wget ftp://ftp.broadinstitute.org/pub/Trinity/Trinotate_v2.0_RESOURCES/uniprot_sprot.trinotate_v2.0.pep.gz
    mv uniprot_sprot.trinotate_v2.0.pep.gz uniprot_sprot.trinotate.pep.gz
    gunzip uniprot_sprot.trinotate.pep.gz
    makeblastdb -in uniprot_sprot.trinotate.pep -dbtype prot


   Run blast to find homologies.

   1. search Trinity transcripts::

	blastx -query trinity_out_dir/Trinity.fasta -db uniprot_sprot.trinotate.pep -num_threads 4 -max_target_seqs 1 -outfmt 6 > blastx.outfmt6

   2. search Transdecoder-predicted proteins::

	blastp -query Trinity.fasta.transdecoder_dir/longest_orfs.pep -db uniprot_sprot.trinotate.pep -num_threads 4 -max_target_seqs 1 -outfmt 6 > blastp.outfmt6

    
b) Optional: Uniref90 which provides clustered sets of protein sequences in a way such that each cluster is composed of sequences that have at least 90% sequence identity to, and 80% overlap with, the longest sequence::

    wget ftp://ftp.broadinstitute.org/pub/Trinity/Trinotate_v2.0_RESOURCES/uniprot_uniref90.trinotate_v2.0.pep.gz
    mv uniprot_uniref90.trinotate_v2.0.pep.gz uniprot_uniref90.trinotate.pep.gz
    gunzip uniprot_uniref90.trinotate.pep.gz
    makeblastdb -in uniprot_uniref90.trinotate.pep -dbtype prot
  

   perform similar searches using uniref90 as the target database, rename output files accordingly::

     blastx -query trinity_out_dir/Trinity.fasta -db uniprot_uniref90.trinotate.pep -num_threads 4 -max_target_seqs 1 -outfmt 6 > uniref90.blastx.outfmt6
     blastp -query Trinity.fasta.transdecoder_dir/longest_orfs.pep -db uniprot_uniref90.trinotate.pep -num_threads 4 -max_target_seqs 1 -outfmt 6 > uniref90.blastp.outfmt6

I have ran them overnight already. You can download these files to save time::

  wget https://github.com/ngs-docs/2015-may-nonmodel/blob/master/_static/uniref90.blastp.outfmt6
  wget https://github.com/ngs-docs/2015-may-nonmodel/blob/master/_static/uniref90.blastx.outfmt6

Characterization of functional annotation features
--------------------------------------------------

1. identify protein domains: we need to install HMMER and download the Pfam domains database::

    sudo apt-get install -y hmmer

Then we can run hmmer to identify the protein domains::
     
    cd /mnt/work
    wget ftp://ftp.broadinstitute.org/pub/Trinity/Trinotate_v2.0_RESOURCES/Pfam-A.hmm.gz
    gunzip Pfam-A.hmm.gz
    hmmpress Pfam-A.hmm
    hmmscan --cpu 4 --domtblout TrinotatePFAM.out Pfam-A.hmm Trinity.fasta.transdecoder_dir/longest_orfs.pep > pfam.log

2. We can predict other features like

   * signal peptides: using signalP
   * transmembrane regions: using tmHMM
   * rRNA transcripts: using RNAMMER


Integration of all annotations into one database
------------------------------------------------

install Trinotate::

   cd
   curl -L https://github.com/Trinotate/Trinotate/archive/v2.0.2.tar.gz > trinotate.tar.gz
   tar xzf trinotate.tar.gz
   mv Trinotate* Trinotate

install `sqlite <http://www.sqlite.org/>`__ ::

   sudo apt-get install sqlite3
  
.. cd
   wget http://www.sqlite.org/2015/sqlite-shell-linux-x86-3080900.zip
   sudo apt-get install unzip
   unzip sqlite*.zip

We need also the DBI perl package::

   sudo cpan DBI
   sudo cpan DBD::SQLite

Retrieve the Trinotate Pre-generated Resource SQLite database
A pregenerated sqlite database that contains Uniprot (swissprot and uniref90)-related annotation information is available from the Trinity ftp site::

   cd /mnt/work
   wget "ftp://ftp.broadinstitute.org/pub/Trinity/Trinotate_v2.0_RESOURCES/Trinotate.sprot_uniref90.20150131.boilerplate.sqlite.gz" -O Trinotate.sqlite.gz
   gunzip Trinotate.sqlite.gz

Load transcripts and coding regions. We have three data types:

1. Transcript sequences (de novo assembled transcripts or reference transcripts)
2. Protein sequences (currently as defined by TransDecoder)
3. Gene/Transcript relationships

::
   
   ~/Trinotate/Trinotate Trinotate.sqlite init --gene_trans_map Trinity.fasta.gene_trans_map --transcript_fasta trinity_out_dir/Trinity.fasta --transdecoder_pep Trinity.fasta.transdecoder_dir/longest_orfs.pep


Loading BLAST homologies::

   ~/Trinotate/Trinotate Trinotate.sqlite LOAD_swissprot_blastp blastp.outfmt6
   ~/Trinotate/Trinotate Trinotate.sqlite LOAD_swissprot_blastx blastx.outfmt6

Optional: load Uniref90 blast hits::

   ~/Trinotate/Trinotate Trinotate.sqlite LOAD_trembl_blastp uniref90.blastp.outfmt6
   ~/Trinotate/Trinotate Trinotate.sqlite LOAD_trembl_blastx uniref90.blastx.outfmt6
   
Optional: Loading functional annotation features::

   ~/Trinotate/Trinotate Trinotate.sqlite LOAD_pfam TrinotatePFAM.out

.. ~/Trinotate/Trinotate Trinotate.sqlite LOAD_tmhmm tmhmm.out
   ~/Trinotate/Trinotate Trinotate.sqlite LOAD_signalp signalp.out

Output an Annotation Report
---------------------------
::
   
   ~/Trinotate/Trinotate Trinotate.sqlite report -E 0.0001 > trinotate_annotation_report.xls

There are 2 arguments that we can use to control the accuracy of annotation

-E <float> : maximum E-value for reporting best blast hit and associated annotations.

--pfam_cutoff <string>

1. 'DNC' : domain noise cutoff (default)
2. 'DGC' : domain gathering cutoff
3. 'DTC' : domain trusted cutoff
4. 'SNC' : sequence noise cutoff
5. 'SGC' : sequence gathering cutoff
6. 'STC' : sequence trusted cutoff


let us see the output. Open a new shell::

  scp -i YOUR_SECURITY_KEY.pem ubuntu@YOUR_AMAZONE_INSTANCE_ADDRESS:/mnt/work/trinotate_annotation_report.xls .

