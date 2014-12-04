Mapping reads to the transcriptome with TopHat
==============================================

@@

1. Grab reference.

2. Load and execute TopHat.

Load the TopHat software::

   module load TopHat2/2.0.8b

And run TopHat::

      tophat -p 4 \
       -G /mnt/scratch/ctb/rna/Homo_sapiens/Ensembl/GRCh37/Annotation/Genes/genes.gtf \
       --transcriptome-index=/mnt/scratch/ctb/rna/transcriptome \
       -o tophat_salivary_repl1 \
       /mnt/scratch/ctb/rna/Homo_sapiens/Ensembl/GRCh37/Sequence/Bowtie2Index/genome \
       salivary_repl1_R1.qc.fq.gz salivary_repl1_R2.qc.fq.gz 

Questions:

* What are all these parameters??
* How do we pick the transcriptome/genome?
* Why is it so slow?

Links:

* `TopHat manual <http://ccb.jhu.edu/software/tophat/manual.shtml>`__
* `Illumina iGenomes project <http://cufflinks.cbcb.umd.edu/igenomes.html>`__

Next: :doc:`m-htseq`
