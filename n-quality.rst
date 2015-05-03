Short read quality and trimming
===============================

.. note::

   Reminder: if you're on Windows, you should install `mobaxterm <http://mobaxterm.mobatek.net/download.html>`__.

OK, you should now be logged into your Amazon computer! How exciting!

Prepping the computer
---------------------

::

   sudo chmod a+rwxt /mnt

   sudo apt-get update
   sudo apt-get install -y trimmomatic fastqc

Data source
-----------

We're going to be using a subset of @@

You can find the full data set on the Short Read Archive under the
accession number on the paper: http://www.ebi.ac.uk/ena/data/view/SRA055442 @@

1. Copying in some data to work with.
-------------------------------------

We've loaded subsets of the data onto an Amazon location@@ for you, to
make everything faster for today's work.  Let's grab the first two files::

   mkdir /mnt/data
   sudo ln -fs /mnt/data /data

   cd /mnt/data

   # @@ break these out into separate files?
   curl -O http://athyra.idyll.org/~t/mrnaseq-subset.tar
   tar xvf mrnaseq-subset.tar

Now if you type::

   ls -l

you should see something like @@::

   -rw-rw-r-- 1 ubuntu ubuntu 7920534 Mar  4 14:49 SRR534005_1.fastq.gz
   -rw-rw-r-- 1 ubuntu ubuntu 8229042 Mar  4 14:49 SRR534005_2.fastq.gz

These are 100,000 read subsets of the original two SRA files.

One problem with these files is that they are writeable - by default, UNIX
makes things writeable by the file owner.  Let's fix that before we go
on any further::

   chmod u-w

1. Copying in some data to work with.
-------------------------------------

First, make a working directory; this will be a place where you can futz
around with a copy of the data without messing up your primary data::

   mkdir /mnt/work
   cd /mnt/work

Now, make a "virtual copy" of the data in your working directory, but under
better names::

   ln -fs /data/* .

These are FASTQ files -- let's take a look at them::

   less 0Hour_ATCACG_L002_R1_001.extract.fastq.gz

(use the spacebar to scroll down, and type 'q' to exit 'less')

Question:

* why are some files named SRR*?
* why are some files named female*?
* why are there R1 and R2 in the file names?
* why don't we combine the files?

Links:

* `FASTQ Format <http://en.wikipedia.org/wiki/FASTQ_format>`__

2. FastQC
---------

We're going to use `FastQC
<http://www.bioinformatics.babraham.ac.uk/projects/fastqc/>`__ to
summarize the data. We already installed 'fastqc' on our computer -
that's what the 'apt-get install' did, above.

Now, run FastQC on two files::

   fastqc 0Hour_ATCACG_L002_R1_001.extract.fastq.gz
   fastqc 0Hour_ATCACG_L002_R2_001.extract.fastq.gz

Now type 'ls'::

   ls

and you will see @@::

   female_repl1_R1_fastqc.html
   female_repl1_R1_fastqc.zip
   female_repl1_R2_fastqc.html
   female_repl1_R2_fastqc.zip

We are *not* going to show you how to look at these files right now -
you need to copy them to your local computer.  We'll show you that
tomorrow.  But! we can show you what they look like, because I've
copied them somewhere public for you: `0Hour_ATCACG_L002_R1_001.extract_fastqc/fastqc_report.html
<http://2015-may-nonmodel.readthedocs.org/en/latest/_static/0Hour_ATCACG_L002_R1_001.extract_fastqc/fastqc_report.html>`__
and `female_repl1_R2.fq_fastqc/fastqc_report.html
<http://2015-mar-semimodel.readthedocs.org/en/latest/_static/female_repl1_R2.fq_fastqc/fastqc_report.html>`__.

Questions:

* What should you pay attention to in the FastQC report?
* Which is "better", R1 or R2?

Links:

* `FastQC <http://www.bioinformatics.babraham.ac.uk/projects/fastqc/>`__
* `FastQC tutorial video <http://www.youtube.com/watch?v=bz93ReOv87Y>`__

3. Trimmomatic
--------------

Now we're going to do some trimming!  We'll be using
`Trimmomatic <http://www.usadellab.org/cms/?page=trimmomatic>`__, which
(as with fastqc) we've already installed via apt-get.

The first thing we'll need are the adapters to trim off::

  curl -O -L http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-semi-2015-03-04/TruSeq2-PE.fa

Now, to run Trimmomatic::

   TrimmomaticPE female_repl1_R1.fq.gz female_repl1_R2.fq.gz\
        female_repl1_R1.qc.fq.gz s1_se female_repl1_R2.qc.fq.gz s2_se \
        ILLUMINACLIP:TruSeq2-PE.fa:2:40:15 \
        LEADING:2 TRAILING:2 \                            
        SLIDINGWINDOW:4:2 \
        MINLEN:25

You should see output that looks like this::

   ...
   Quality encoding detected as phred33
   Input Read Pairs: 100000 Both Surviving: 96615 (96.62%) Forward Only Surviving: 3282 (3.28%) Reverse Only Surviving: 95 (0.10%) Dropped: 8 (0.01%)
   TrimmomaticPE: Completed successfully
   ...

Questions:

* How do you figure out what the parameters mean?
* How do you figure out what parameters to use?
* What adapters do you use?
* What version of Trimmomatic are we using here? (And FastQC?)
* Are parameters different for RNAseq and genomic?
* What's with these annoyingly long and complicated filenames?
* What do we do with the single-ended files (s1_se and s2_se?)

For a discussion of optimal RNAseq trimming strategies, see `MacManes,
2014
<http://journal.frontiersin.org/Journal/10.3389/fgene.2014.00013/abstract>`__.

Links:

* `Trimmomatic <http://www.usadellab.org/cms/?page=trimmomatic>`__

4. FastQC again
---------------

Run FastQC again::

   fastqc female_repl1_R1.qc.fq.gz
   fastqc female_repl1_R2.qc.fq.gz

And now view my copies of these files: `female_repl1_R1.qc.fq_fastqc/fastqc_report.html
<http://2015-mar-semimodel.readthedocs.org/en/latest/_static/female_repl1_R1.qc.fq_fastqc/fastqc_report.html>`__
and `female_repl1_R2.qc.fq_fastqc/fastqc_report.html
<http://2015-mar-semimodel.readthedocs.org/en/latest/_static/female_repl1_R2.qc.fq_fastqc/fastqc_report.html>`__.

Let's take a look at the output files::

   less female_repl1_R1.qc.fq.gz

(again, use spacebar to scroll, 'q' to exit less).

Questions:

* Why are some of the reads shorter than others?
* is the quality trimmed data "better" than before?
* Does it matter that you still have adapters!?

5. Subset and trim the rest of the sequences
--------------------------------------------

Now let's download all the rest of the samples::

   cd /mnt/data
   curl -O -L http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-semi-2015-03-04/SRR534006_1.fastq.gz
   curl -O -L http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-semi-2015-03-04/SRR534006_2.fastq.gz
   curl -O -L http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-semi-2015-03-04/SRR536786_1.fastq.gz
   curl -O -L http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-semi-2015-03-04/SRR536786_2.fastq.gz
   curl -O -L http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-semi-2015-03-04/SRR536787_1.fastq.gz
   curl -O -L http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-semi-2015-03-04/SRR536787_2.fastq.gz
   chmod u-w *.gz

Go back to the work directory, and copy them in::

   cd /mnt/work
   ln -fs /mnt/data/SRR534006_1.fastq.gz female_repl2_R1.fq.gz 
   ln -fs /mnt/data/SRR534006_2.fastq.gz female_repl2_R2.fq.gz 

   ln -fs /mnt/data/SRR536786_1.fastq.gz male_repl1_R1.fq.gz 
   ln -fs /mnt/data/SRR536786_2.fastq.gz male_repl1_R2.fq.gz 

   ln -fs /mnt/data/SRR536787_1.fastq.gz male_repl2_R1.fq.gz 
   ln -fs /mnt/data/SRR536787_2.fastq.gz male_repl2_R2.fq.gz 

   TrimmomaticPE female_repl2_R1.fq.gz female_repl2_R2.fq.gz\
        female_repl2_R1.qc.fq.gz s1_se female_repl2_R2.qc.fq.gz s2_se \
        ILLUMINACLIP:TruSeq2-PE.fa:2:40:15 \
        LEADING:2 TRAILING:2 \                            
        SLIDINGWINDOW:4:2 \
        MINLEN:25

   TrimmomaticPE male_repl1_R1.fq.gz male_repl1_R2.fq.gz\
        male_repl1_R1.qc.fq.gz s1_se male_repl1_R2.qc.fq.gz s2_se \
        ILLUMINACLIP:TruSeq2-PE.fa:2:40:15 \
        LEADING:2 TRAILING:2 \                            
        SLIDINGWINDOW:4:2 \
        MINLEN:25
   
   TrimmomaticPE male_repl2_R1.fq.gz male_repl2_R2.fq.gz\
        male_repl2_R1.qc.fq.gz s1_se male_repl2_R2.qc.fq.gz s2_se \
        ILLUMINACLIP:TruSeq2-PE.fa:2:40:15 \
        LEADING:2 TRAILING:2 \                            
        SLIDINGWINDOW:4:2 \
        MINLEN:25
   
Next: :doc:`s-building-a-reference`
