Mapping reads to the transcriptome with TopHat
==============================================

Now that we have some quality-controlled reads and a new reference
transcriptome, we're going to map the
reads to the reference genome, **using the new reference transcriptome**.
We'll again be using the `TopHat software
<http://ccb.jhu.edu/software/tophat/manual.shtml>`__

Mapping reads
-------------

Now run TopHat on one of the individual samples::

   cd /mnt/work
   tophat -p 4 \
       -G cuffmerge_all/nostrand.gtf \
       --transcriptome-index=/mnt/genome/tophat/merged \
       -o tophat_female_repl1 \
       /mnt/genome/Gallus_gallus/UCSC/galGal3/Sequence/Bowtie2Index/genome \
       female_repl1_R1.qc.fq.gz female_repl1_R2.qc.fq.gz 

This will take about 15 minutes.

Questions:

* How do we pick the transcriptome/genome?

Viewing the mapped reads percentage
-----------------------------------

Let's look at these numbers specifically::

   less tophat_female_repl1/align_summary.txt

Making gene counts
------------------

Now that we know which reads go with which gene, we'll use
`htseq-count <http://www-huber.embl.de/users/anders/HTSeq/doc/count.html>`__.

Install::

   sudo apt-get install -y build-essential python2.7-dev python-numpy \
         python-matplotlib python-pip zlib1g-dev

And then separately::

   sudo pip install pysam
   sudo pip install HTSeq

(This will take about 5 minutes.)

Now run HTSeq::

   htseq-count --format=bam --stranded=no --order=pos \
       tophat_female_repl1/accepted_hits.bam \
       cuffmerge_all/nostrand.gtf > female_repl1_counts.txt

When this is done, type::

   less female_repl1_counts.txt

(again, use 'q' to exit).  These are your gene counts.

Note, these are *raw* gene counts - the number of reads that map to
each feature (gene, in this case).  They are not normalized by length
of gene. According to `this post on seqanswers
<http://seqanswers.com/forums/archive/index.php/t-9998.html>`__, both
DEseq and edgeR want exactly this kind of information!

Questions:

* what are the 'XLOC...' names?
* what do these parameters mean?
* what parameters does HTSeq take?
* why are we using so many programs?

Links:

* `HTSeq <http://www-huber.embl.de/users/anders/HTSeq/doc/overview.html>`__
* `htseq-count documentation <http://www-huber.embl.de/users/anders/HTSeq/doc/count.html>`__

Next: :doc:`s-more-tophat`
