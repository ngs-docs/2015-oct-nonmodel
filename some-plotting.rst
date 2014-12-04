Making an MA Plot
=================

See: http://2014-msu-rnaseq.readthedocs.org/en/latest/_static/lung_saliva.R

To run it, do::

   curl -O http://2014-msu-rnaseq.readthedocs.org/en/latest/_static/lung_saliva.R
   cp lung_repl1_counts.txt lung_repl2_counts.txt
   cp salivary_repl1_counts.txt salivary_repl2_counts.txt

   Rscript lung_saliva.R

and then copy the output file 'edgeR-MA-plot.pdf' back to your computer.
It will be in the directory '~/rnaseq/edgeR-MA-plot.pdf'.

You can also look at `my output <http://2014-msu-rnaseq.readthedocs.org/en/latest/_static/edgeR-MA-plot.pdf>`__.
