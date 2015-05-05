Tips and Tricks for working with Remote Computers
=================================================

Use screen to run things that take a long time.
-----------------------------------------------

Often you want to run things that will take days or weeks to run.  The 'screen'
command will let you run programs and record the output, and then come
back later and "reconnect".

For example, try running the beginning bit of digital normalization
(:doc:`n-diginorm`) inside of screen::

   screen
   cd /mnt/work
   normalize-by-median.py -k 20 -p -C 20 -N 4 -x 2e9 -s normC20k20.ct *.pe.qc.fq.gz

The normalize-by-median command will take a while, but now that it's
running in screen, you can "detach" from your remote computer and
walk away for a bit.  For example, 

* close your terminal window;
* open up a new one and connect into your Amazon machine;
* type 'screen -r' to reconnect into your running screen.

(See :doc:`amazon/using-screen` for a more complete rundown on
instructions.)

Use CyberDuck to transfer files
-------------------------------

To transfer remote files to your local laptop, or local laptop files to the
remote system, try using `CyberDuck <https://cyberduck.io/?l=en>`__.  We'll
walk through it in class.

Subsetting data
---------------

If you want to generate a small subset of a FASTQ file for testing,
you can do something like this::

   gunzip -c /mnt/data/SRR534005_1.fastq.gz | head -400000 | gzip > sample.fq.gz

This will take 400,000 lines (or 100,000 FASTQ records) from the beginning
of the ``SRR534005_1.fastq.gz`` file and put them in the ``sample.fq.gz``
file.

Running full analyses on Amazon Web Services
--------------------------------------------

You need to do three things to run a full analysis on AWS (or really
any cloud machine) --

1. you need to get your data onto that machine.

2. you need to be prepared to let things run for a long time.

3. you need to have a large disk to store all the intermediate files.
   A good rule of thumb is that every 200 million reads requires about a
   TB of intermediate disk space.

Getting your data onto the machine can be done by using the 'curl' command
to download data from (e.g.) your sequencing core.  This will be core
specific and it's something we can help you with when you need the help.

To let things run for a long time, you basically need to run them in screen
(see above, "Use screen.")

By default, Amazon doesn't give you really big hard disks on your machine --
you can use 'df' to take a look.  On an m3.xlarge machine, you can ask about
disk space on /mnt by using 'df' (disk free)::

   df -k /mnt

You should see something like this::

   Filesystem     1K-blocks     Used Available Use% Mounted on
   /dev/xvdb       38565344 20098736  16500940  55% /mnt

which tells you that /mnt has 40 GB of disk space.

To add disk space to your Amazon instance, see this set of instructions:

http://angus.readthedocs.org/en/2014/amazon/setting-up-an-ebs-volume.html

The simplest advice is to make /mnt a 1 TB disk, which should hold a half
dozen mRNAseq data sets and all the intermediate data.
