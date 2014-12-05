Data analysis & differential expression
=======================================

We'll be using `edgeR
<http://www.bioconductor.org/packages/release/bioc/html/edgeR.html>`__
to do the basic differential expression analysis of our counts.

To run edgeR, you need to write a data loading and manipulation script
in R.  In this case, I've provided one -- `lung_saliva.R
<http://www.datacarpentry.org/>`__.  This script will load in two
samples with two replicates, execute an MA plot, and provide a spreadsheet
with differential expression information in it.

Links:

* `False Discovery Rate <http://en.wikipedia.org/wiki/False_discovery_rate>`__
* `Learn R with Swirl <http://swirlstats.com/>`__
* `Data Carpentry <http://www.datacarpentry.org/>`__

Running edgeR on a data subset
==============================

To download the script and data files for the 100k read subsets, do::

   curl -O http://2014-msu-rnaseq.readthedocs.org/en/latest/_static/lung_saliva.R
   curl -O http://2014-msu-rnaseq.readthedocs.org/en/latest/_static/files/subset/lung_repl1_counts.txt
   curl -O http://2014-msu-rnaseq.readthedocs.org/en/latest/_static/files/subset/lung_repl2_counts.txt
   curl -O http://2014-msu-rnaseq.readthedocs.org/en/latest/_static/files/subset/salivary_repl1_counts.txt
   curl -O http://2014-msu-rnaseq.readthedocs.org/en/latest/_static/files/subset/salivary_repl2_counts.txt

Note: the ``saliva_repl1_counts.txt`` and ``lung_repl1_counts.txt``
are the files produced by :doc:`m-tophat` and :doc:`m-more-tophat`,
respectively.  I've also run them on the replicate data sets.

Next, to run the R script, do::

   module load R
   Rscript lung_saliva.R

This will produce two files, `edgeR-MA-plot.pdf <http://2014-msu-rnaseq.readthedocs.org/en/latest/_static/subset/edgeR-MA-plot.pdf>`__ and `edgeR-lung-vs-salivary.csv <http://2014-msu-rnaseq.readthedocs.org/en/latest/_static/subset/edgeR-lung-vs-salivary.csv>`__.

Next: :doc:`m-hpc-qsub`
