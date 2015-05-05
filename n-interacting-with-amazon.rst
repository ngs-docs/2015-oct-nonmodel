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
