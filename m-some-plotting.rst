Making an MA Plot
=================

Here is `an R script to calculate an MA-Plot
<https://raw.githubusercontent.com/ngs-docs/2014-msu-rnaseq/master/files/lung_saliva.R>`__.

To run it, do::

   curl -O http://2014-msu-rnaseq.readthedocs.org/en/latest/_static/lung_saliva.R
   cp lung_repl1_counts.txt lung_repl2_counts.txt
   cp salivary_repl1_counts.txt salivary_repl2_counts.txt

   module load R
   Rscript lung_saliva.R

and then copy the output file 'edgeR-MA-plot.pdf' back to your computer.
It will be in the directory '~/rnaseq/edgeR-MA-plot.pdf'.

You can also look at `my output <http://2014-msu-rnaseq.readthedocs.org/en/latest/_static/edgeR-MA-plot.pdf>`__.
