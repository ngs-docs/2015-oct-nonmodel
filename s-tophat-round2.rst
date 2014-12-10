Mapping reads to the transcriptome with TopHat
==============================================

Now that we have some quality-controlled reads and a new reference
transcriptome, we're going to map the
reads to the reference genome, **using the new reference transcriptome**.
We'll again be using the `TopHat software
<http://ccb.jhu.edu/software/tophat/manual.shtml>`__

Mapping reads
-------------

Load the TopHat software, if you haven't already::

   module load TopHat2/2.0.12

And now run TopHat::

   cd ~/rnaseq
   tophat -p 4 \
       -G cuffmerge_all/nostrand.gtf \
       --transcriptome-index=$HOME/RNAseq-semimodel/tophat/merged \
       -o tophat_female_repl1 \
       ~/RNAseq-semimodel/reference/Gallus_gallus/UCSC/galGal3/Sequence/Bowtie2Index/genome \
       female_repl1_R1.qc.fq.gz female_repl1_R2.qc.fq.gz 

This will take about 15 minutes.

Questions:

* How do we pick the transcriptome/genome?

Counting mapped reads percentage
--------------------------------

Let's look at these numbers specifically::

   less tophat_female_repl1/align_summary.txt

----

.. Next: :doc:`m-htseq`
