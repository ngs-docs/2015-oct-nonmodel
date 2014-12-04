Short read quality and trimming
===============================

Log into the HPC.  (More soon.)

0. Getting the data
-------------------

We'll be using a few RNAseq data sets from Fagerberg et al., `Analysis
of the Human Tissue-specific Expression by Genome-wide Integration of
Transcriptomics and Antibody-based Proteomics
<http://www.mcponline.org/content/13/2/397.full>`__.

You can get this data from the European Nucleotide Archive under
ERP003613 -- go to http://www.ebi.ac.uk/ena/data/view/ERP003613
to see all the samples.

I picked two samples: `salivary gland
<http://www.ebi.ac.uk/ena/data/view/SAMEA2151887>`__ and `lung
<http://www.ebi.ac.uk/ena/data/view/SAMEA2155770>`__.  Note that each
sample has two replicates, and each replicate has two files.

**Don't download them**, but if you were downloading these yourself,
you would want the "Fastq files (ftp)", both File 1 and File 2.  (They
take a few hours to download!)

I've put them @@. Do ::

   ls -l @@

You'll see something like ::

   -r--r--r-- 1 ctb ged-lab 879551444 Dec  3 12:22 ERR315325_1.fastq.gz

which tells you that this file is 900,000,000 bytes or about 900 MB.
Quite large!

1. Copying in some data to work with.
-------------------------------------

First, make a directory::

   mkdir ~/rnaseq
   cd ~/rnaseq

Copy in a subset of the data (100,000 sequences)::

   gunzip -c /mnt/scratch/ctb/rna/ERR315325_1.fastq.gz | head -400000 | gzip > salivary_repl1_R1.fq.gz
   gunzip -c /mnt/scratch/ctb/rna/ERR315325_2.fastq.gz | head -400000 | gzip > salivary_repl1_R2.fq.gz

These are FASTQ files -- let's take a look::

   less salivary_repl1_R1.fq.gz

(type 'q' to exit less)

Question:

* what's the ERR* name?
* what's the salivary* name?
* why is there R1 and R2?

Links:

* `FASTQ Format <http://en.wikipedia.org/wiki/FASTQ_format>`__

2. FastQC
---------

We're going to use `FastQC <http://www.bioinformatics.babraham.ac.uk/projects/fastqc/>`__ to summarize the data.

First, we need to load the FastQC software into our account::

   module load FastQC/0.11.2

(You have to do this each time you log in and want to use FastQC.)

Now, run FastQC on both of the salivary gland files::

   fastqc salivary_repl1_R1.fq.gz
   fastqc salivary_repl1_R2.fq.gz

Now type 'ls'::

   ls

and you will see 

   salivary_repl1_R1_fastqc.html
   salivary_repl1_R1_fastqc.zip
   salivary_repl1_R2_fastqc.html
   salivary_repl1_R2_fastqc.zip

Copy these to your laptop and open them in a browser.  If you're on a
Mac or Linux machine, you can type::

   scp username@hpc.msu.edu:salivary*fastqc.* /tmp

and then open the html files in your browser.  For Windows, we'll
figure it out ;).

Links:

* `FastQC <http://www.bioinformatics.babraham.ac.uk/projects/fastqc/>`__

3. Trimmomatic
--------------

4. FastQC
---------