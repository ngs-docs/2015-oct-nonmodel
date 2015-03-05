Tips and Tricks for working with Remote Computers
=================================================

Use screen to run things that take a long time.
-----------------------------------------------

Often you want to run things that will take days or weeks to run.  The 'screen'
command will let you run programs and record the output, and then come
back later and "reconnect".

(See :doc:`amazon/using-screen` for instructions.)

Use CyberDuck to transfer files
-------------------------------

To transfer remote files to your local laptop, or local laptop files to the
remote system, try using `CyberDuck <https://cyberduck.io/?l=en>`__.

Subsetting data
---------------

If you want to generate a small subset of a FASTQ file for testing,
you can do something like this::

   gunzip -c /mnt/data/SRR534005_1.fastq.gz | head -400000 | gzip > sample.fq.gz

This will take 400,000 lines (or 100,000 FASTQ records) from the beginning
of the ``SRR534005_1.fastq.gz`` file and put them in the ``sample.fq.gz``
file.
