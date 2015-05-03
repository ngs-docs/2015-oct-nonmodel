Running the actual assembly
===========================

Now we'll assemble all of these reads into a transcriptome, using
`the Trinity de novo transcriptome assembler <http://trinityrnaseq.github.io/>`__.

First, install some prerequisites for Trinity::

   sudo apt-get -y install bowtie samtools

Next, install Trinity v2.0.6::

   cd 
   curl -L https://github.com/trinityrnaseq/trinityrnaseq/archive/v2.0.6.tar.gz > trinity.tar.gz
   tar xzf trinity.tar.gz
   mv trinityrnaseq* trinity/

   cd trinity
   make

Go into the work directory, and prepare the data::

   cd /mnt/work
   for i in *.dn.fq.gz
   do
      split-paired-reads.py $i
   done

   cat *.1 > left.fq
   cat *.2 > right.fq

Now, run the Trinity assembler::

   ~/trinity/Trinity --left left.fq --right right.fq --seqType fq --max_memory 10G --bypass_java_version_check

This will give you an output file ``trinity_out_dir/Trinity.fasta``, which
you can get stats on like so::

   curl -L -O https://github.com/ged-lab/khmer/raw/v1.3/sandbox/assemstats3.py
   python assemstats3.py 300 trinity_out_dir/Trinity.fasta

Change the filename and rename all the sequences::

   gzip -c trinity_out_dir/Trinity.fasta > trinity-nematostella-raw.fa.gz
   curl -O http://2015-may-nonmodel.readthedocs.org/en/dev/_static/rename-with-partitions.py
   chmod u+x rename-with-partitions.py
   ./rename-with-partitions.py nema trinity-nematostella-raw.fa.gz

This last command will give you
``trinity-nematostella-raw.renamed.fasta.gz``, which contains all of
the renamed sequences.


