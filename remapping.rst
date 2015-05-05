Remapping your reads to your assembled transcriptome
====================================================

First, we'll need to make sure `bowtie2
<http://bowtie-bio.sourceforge.net/bowtie2/manual.shtml>`__ is
installed::

   sudo apt-get install -y bowtie2

Now, create a bowtie2 index out of your transcriptome::

   gunzip -c trinity-nematostella-raw.renamed.fasta.gz > trinity-nematostella-raw.renamed.fasta
   bowtie2-build  trinity-nematostella-raw.renamed.fasta transcriptome

And then, finally, count the number of reads that map to your transcriptome::

   zcat 0Hour_ATCACG_L002_R1_001.extract.fastq.gz | \
        head -400000 | \
        bowtie2 -U - -x transcriptome > /dev/null

You should get something like::

   97.18% overall alignment rate
