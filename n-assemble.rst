Running the actual assembly
===========================

::

   sudo apt-get -y install bowtie samtools

Install Trinity::

   cd 
   curl -L https://github.com/trinityrnaseq/trinityrnaseq/archive/v2.0.6.tar.gz > trinity.tar.gz
   tar xzf trinity.tar.gz
   mv trinityrnaseq* trinity/

   cd trinity
   make


   cd /mnt/work
   for i in *.kak.fq.gz
   do
      split-paired-reads.py $i
   done

   cat *.1 > left.fq
   cat *.2 > right.fq

   ~/trinity/Trinity --left left.fq --right right.fq --seqType fq --max_memory 10G --bypass_java_version_check

   curl -L -O https://github.com/ged-lab/khmer/raw/v1.3/sandbox/assemstats3.py

   python assemstats3.py 300 trinity_out_dir/Trinity.fasta

   gzip -c trinity_out_dir/Trinity.fasta > trinity-nematostella-raw.fa.gz

   ##wget https://raw.githubusercontent.com/ctb/eel-pond/protocols-v0.8.3/rename-with-partitions.py
   chmod u+x rename-with-partitions.py
   ./rename-with-partitions.py nema trinity-nematostella-raw.fa.gz

   # trinity-nematostella-raw.renamed.fasta.gz


