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
   sudo apt-get install -y trimmomatic fastqc python-pip python-dev

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

   chmod u-w *

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
and `0Hour_ATCACG_L002_R2_001.extract_fastqc/fastqc_report.html
<http://2015-may-nonmodel.readthedocs.org/en/latest/_static/0Hour_ATCACG_L002_R2_001.extract_fastqc/fastqc_report.html>`__.

Questions:

* What should you pay attention to in the FastQC report?
* Which is "better", R1 or R2? And why?

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

   TrimmomaticPE 0Hour_ATCACG_L002_R1_001.extract.fastq.gz \
                 0Hour_ATCACG_L002_R2_001.extract.fastq.gz \
        0Hour_ATCACG_L002_R1_001.qc.fq.gz s1_se \
        0Hour_ATCACG_L002_R2_001.qc.fq.gz s2_se \
        ILLUMINACLIP:TruSeq2-PE.fa:2:40:15 \
        LEADING:2 TRAILING:2 \                            
        SLIDINGWINDOW:4:2 \
        MINLEN:25

You should see output that looks like this::

   ...
   Quality encoding detected as phred33
   Input Read Pairs: 140557 Both Surviving: 138775 (98.73%) Forward Only Surviving: 1776 (1.26%) Reverse Only Surviving: 6 (0.00%) Dropped: 0 (0.00%)
   TrimmomaticPE: Completed successfully   ...

Questions:

* How do you figure out what the parameters mean?
* How do you figure out what parameters to use?
* What adapters do you use?
* What version of Trimmomatic are we using here? (And FastQC?)
* Are parameters different for RNAseq and genomic?
* What's with these annoyingly long and complicated filenames?
* why are we running R1 and R2 together?
* What do we do with the single-ended files (s1_se and s2_se?)

For a discussion of optimal RNAseq trimming strategies, see `MacManes,
2014
<http://journal.frontiersin.org/Journal/10.3389/fgene.2014.00013/abstract>`__.

Links:

* `Trimmomatic <http://www.usadellab.org/cms/?page=trimmomatic>`__

4. FastQC again
---------------

Run FastQC again on the trimmed files::

   fastqc 0Hour_ATCACG_L002_R1_001.qc.fq.gz
   fastqc 0Hour_ATCACG_L002_R2_001.qc.fq.gz

And now view my copies of these files: `0Hour_ATCACG_L002_R1_001.qc.fq_fastqc/fastqc_report.html
<http://2015-may-nonmodel.readthedocs.org/en/latest/_static/0Hour_ATCACG_L002_R1_001.qc.fq_fastqc/fastqc_report.html>`__
and `0Hour_ATCACG_L002_R2_001.qc.fq_fastqc/fastqc_report.html
<http://2015-may-nonmodel.readthedocs.org/en/latest/_static/0Hour_ATCACG_L002_R2_001.qc.fq_fastqc/fastqc_report.html>`__

Let's take a look at the output files::

   less 0Hour_ATCACG_L002_R1_001.qc.fq.gz

(again, use spacebar to scroll, 'q' to exit less).

Questions:

* Why are some of the reads shorter than others?
* is the quality trimmed data "better" than before?
* Does it matter that you still have adapters!?

5. Trim the rest of the sequences
---------------------------------

::

  for filename in *_R1_*.extract.fastq.gz
  do
        # first, make the base by removing .extract.fastq.gz
        base=$(basename $filename .extract.fastq.gz)
        echo $base

        # now, construct the R2 filename by replacing R1 with R2
        baseR2=${base/_R1_/_R2_}
        echo $baseR2

        TrimmomaticPE ${base}.extract.fastq.gz ${baseR2}.extract.fastq.gz \
           ${base}.qc.fq.gz s1_se \
           ${baseR2}.qc.fq.gz s2_se \
           ILLUMINACLIP:TruSeq2-PE.fa:2:40:15 \
           LEADING:2 TRAILING:2 \                            
           SLIDINGWINDOW:4:2 \
           MINLEN:25
  done

Questions:

* what is a for loop?
* how do you figure out if it's working?
   - copy/paste it from Word
   - put in lots of echo
   - edit one line at a time
* how on earth do you figure this stuff out?

6. Interleave the sequences
---------------------------

Install khmer::

  sudo pip install -U setuptools
  sudo pip install khmer==1.3

::

  for filename in *_R1_*.qc.fq.gz
  do
        # first, make the base by removing .extract.fastq.gz
        base=$(basename $filename .qc.fq.gz)
        echo $base

        # now, construct the R2 filename by replacing R1 with R2
        baseR2=${base/_R1_/_R2_}
        echo $baseR2

        # construct the output filename
        output=${base/_R1_/}.pe.qc.fq.gz

        interleave-reads.py ${base}.qc.fq.gz ${baseR2}.qc.fq.gz | \
            gzip > $output
  done
   
Next: :doc:`n-diginorm`

