Annotation of denovo transcriptome
==================================

Indentify the Gene/Transcript relationships:
--------------------------------------------
we can generate this file like so::

   ~/trinity/util/support_scripts/get_Trinity_gene_to_trans_map.pl trinity_out_dir/Trinity.fasta >  Trinity.fasta.gene_trans_map

Generate the longest-ORF peptide candidates from the Trinity Assembly:
----------------------------------------------------------------------
We need to install Transdecoder to do this job::

   cd
   sudo cpan URI::Escape
   .. note:: type yes for all interactive questions
   curl -L https://github.com/TransDecoder/TransDecoder/archive/2.0.1.tar.gz > transdecoder.tar.gz
   tar xzf transdecoder.tar.gz
   mv TransDecoder* TransDecoder
   cd TransDecoder
   make

Now we can run the Transdecoder software to identify the longest-ORF peptide::

   cd /mnt/work
   ~/TransDecoder/TransDecoder.LongOrfs -t trinity_out_dir/Trinity.fasta

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

a) SwissProt databse: The UniProt Knowledgebase which include the Manually annotated proteins::

    cd /mnt/work
    wget ftp://ftp.broadinstitute.org/pub/Trinity/Trinotate_v2.0_RESOURCES/uniprot_sprot.trinotate_v2.0.pep.gz
    mv uniprot_sprot.trinotate_v2.0.pep.gz uniprot_sprot.trinotate.pep.gz
    gunzip uniprot_sprot.trinotate.pep.gz
    makeblastdb -in uniprot_sprot.trinotate.pep -dbtype prot

b) Optional: Uniref90 which provides clustered sets of protein sequences in a way such that each cluster is composed of sequences that have at least 90% sequence identity to, and 80% overlap with, the longest sequence::

    wget ftp://ftp.broadinstitute.org/pub/Trinity/Trinotate_v2.0_RESOURCES/uniprot_uniref90.trinotate_v2.0.pep.gz
    mv uniprot_uniref90.trinotate_v2.0.pep.gz uniprot_uniref90.trinotate.pep.gz
    gunzip uniprot_uniref90.trinotate.pep.g
    makeblastdb -in uniprot_uniref90.trinotate.pep -dbtype prot
  
Run blast to find homolies

1. search Trinity transcripts::
   
    blastx -query trinity_out_dir/Trinity.fasta -db uniprot_sprot.trinotate.pep -num_threads 4 -max_target_seqs 1 -outfmt 6 > blastx.outfmt6

2. search Transdecoder-predicted proteins::

    blastp -query Trinity.fasta.transdecoder_dir/longest_orfs.pep -db uniprot_sprot.trinotate.pep -num_threads 4 -max_target_seqs 1 -outfmt 6 > blastp.outfmt6


3. Optional: perform similar searches using uniref90 as the target database, rename output files accordingly::

    blastx -query trinity_out_dir/Trinity.fasta -db uniprot_uniref90.trinotate.pep -num_threads 4 -max_target_seqs 1 -outfmt 6 > uniref90.blastx.outfmt6
    blastp -query Trinity.fasta.transdecoder_dir/longest_orfs.pep -db uniprot_uniref90.trinotate.pep -num_threads 4 -max_target_seqs 1 -outfmt 6 > uniref90.blastp.outfmt6

Characterization of functional annotation features
--------------------------------------------------

1. identify protein domains: we need to install HMMER and download the Pfam domains database. Then we can run hmmur to identify the protein domains::

    cd
    sudo apt-get install -y hmmer
    cd /mnt/work
    wget ftp://ftp.broadinstitute.org/pub/Trinity/Trinotate_v2.0_RESOURCES/Pfam-A.hmm.gz
    gunzip Pfam-A.hmm.gz
    hmmpress Pfam-A.hmm
    hmmscan --cpu 4 --domtblout TrinotatePFAM.out Pfam-A.hmm transdecoder.pep > pfam.log

2. We can predict other features include

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

install sqlite (required for database integration): http://www.sqlite.org/::

   cd
   wget http://www.sqlite.org/2015/sqlite-shell-linux-x86-3080900.zip
   unzip sqlite*.zip

Retrieve the Trinotate Pre-generated Resource SQLite database
A pregenerated sqlite database that contains Uniprot(swissprot and uniref90)-related annotation information is available from the Trinity ftp site::

   cd /mnt/work
   wget "ftp://ftp.broadinstitute.org/pub/Trinity/Trinotate_v2.0_RESOURCES/Trinotate.sprot_uniref90.20150131.boilerplate.sqlite.gz" -O Trinotate.sqlite.gz
   gunzip Trinotate.sqlite.gz

Load transcripts and coding regions
We have three data types:
1. Transcript sequences (de novo assembled transcripts or reference transcripts)
2. Protein sequences (currently as defined by TransDecoder)
3. Gene/Transcript relationships::
   
   ~/Trinotate Trinotate.sqlite init --gene_trans_map Trinity.fasta.gene_trans_map --transcript_fasta trinity_out_dir/Trinity.fasta --transdecoder_pep transdecoder.pep


Loading BLAST homologies::

   ~/Trinotate Trinotate.sqlite LOAD_swissprot_blastp blastp.outfmt6
   ~/Trinotate Trinotate.sqlite LOAD_swissprot_blastx blastx.outfmt6

Optional: load Uniref90 blast hits::

   ~/Trinotate Trinotate.sqlite LOAD_trembl_blastp uniref90.blastp.outfmt6
   ~/Trinotate Trinotate.sqlite LOAD_trembl_blastx uniref90.blastx.outfmt6
   
Loading functional annotation features::

   ~/Trinotate Trinotate.sqlite LOAD_pfam TrinotatePFAM.out

.. ~/Trinotate Trinotate.sqlite LOAD_tmhmm tmhmm.out
   ~/Trinotate Trinotate.sqlite LOAD_signalp signalp.out

Output an Annotation Report
---------------------------
::
   
   ~/Trinotate Trinotate.sqlite report -E 0.0001 > trinotate_annotation_report.xls

