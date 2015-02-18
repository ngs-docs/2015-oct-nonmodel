Data analysis & differential expression
=======================================

.. note:: if you want to start from here, you can do::

      mkdir ~/rnaseq
      cd ~/rnaseq

   and then run the 'wget' commands below.

At this point, you should have four files::

   female_repl1_counts.txt
   female_repl2_counts.txt
   male_repl1_counts.txt
   male_repl2_counts.txt

If you look at the file content with 'head', ::

   head female_repl1_counts.txt 

you'll see something like this::

   XLOC_000001     1
   XLOC_000002     0
   XLOC_000003     2
   XLOC_000004     0
   XLOC_000005     0
   XLOC_000006     3
   XLOC_000007     2
   XLOC_000008     0
   XLOC_000009     0
   XLOC_000010     14

These are the *unique gene identifiers* from cuffmerge_all.fa, together
with their counts as measured by TopHat and htseq-count.

What we'll do next is compare gene counts across all four files and do
differential expression analysis.

----

We'll be using `edgeR
<http://www.bioconductor.org/packages/release/bioc/html/edgeR.html>`__
to do the basic differential expression analysis of our counts.

To run edgeR, you need to write a data loading and manipulation script
in R.  In this case, I've provided one -- `chick.R
<https://github.com/ngs-docs/2014-msu-rnaseq/blob/master/files/chick.R>`__.
This script will load in two samples with two replicates, execute an
MA plot, do an MDS analysis/plot, and provide a spreadsheet with
differential expression information in it.  To download it, `click
here
<http://2014-msu-rnaseq.readthedocs.org/en/latest/_static/chick.R>`__.

Links:

* `False Discovery Rate <http://en.wikipedia.org/wiki/False_discovery_rate>`__
* `Learn R with Swirl <http://swirlstats.com/>`__
* `Data Carpentry <http://www.datacarpentry.org/>`__

Running edgeR on a data subset
------------------------------

To run the script on the HPC, download the script and data files for
the 100k read subsets.  At the command line, do::

   cd ~/rnaseq
   curl -O http://2014-msu-rnaseq.readthedocs.org/en/latest/_static/chick.R
   curl -O http://2014-msu-rnaseq.readthedocs.org/en/latest/_static/chick-subset/female_repl1_counts.txt
   curl -O http://2014-msu-rnaseq.readthedocs.org/en/latest/_static/chick-subset/female_repl2_counts.txt
   curl -O http://2014-msu-rnaseq.readthedocs.org/en/latest/_static/chick-subset/male_repl1_counts.txt
   curl -O http://2014-msu-rnaseq.readthedocs.org/en/latest/_static/chick-subset/male_repl2_counts.txt

These various .txt files are produced by :doc:`s-tophat-round2`, :doc:`s-more-tophat`, and :doc:`s-even-more-tophat`.

Next, to run the R script, do::

   module load R
   Rscript chick.R

This will produce three files, `chick-edgeR-MA-plot.pdf
<http://2014-msu-rnaseq.readthedocs.org/en/latest/_static/chick-subset/chick-edgeR-MA-plot.pdf>`__,
`chick-edgeR-MDS.pdf
<http://2014-msu-rnaseq.readthedocs.org/en/latest/_static/chick-subset/chick-edgeR-MDS.pdf>`__,
and `chick-edgeR.csv
<http://2014-msu-rnaseq.readthedocs.org/en/latest/_static/chick-subset/chick-edgeR.csv>`__;
they will be in your ``rnaseq`` folder in your home directory
on the HPC.  The CSV file can be opened directly in Excel; you can
also look at it `here
<https://raw.githubusercontent.com/ngs-docs/2014-msu-rnaseq/master/files/chick-subset/chick-edgeR.csv>`__.
It consists of five columns: gene name, log fold change, P-value, and
FDR-adjusted P-value.

If you look closely at `the MA plot
<http://2014-msu-rnaseq.readthedocs.org/en/latest/_static/chick-subset/chick-edgeR-MA-plot.pdf>`__,
you'll see that there are three red dots.  These are the genes with a
False Discovery Rate of 0.2 or less (see `chick.R
<https://github.com/ngs-docs/2014-msu-rnaseq/blob/master/files/chick.R#L28>`__),
line 28.
Note that the axes on the MA plot are counts per million (CPM, X axis) and
fold change (Y axis).

Next, let's take a look at `chick-edgeR.csv
<https://github.com/ngs-docs/2014-msu-rnaseq/blob/master/files/chick-subset/chick-edgeR.csv>`__.
This is a comma-separated value file that you can `download
<http://2014-msu-rnaseq.readthedocs.org/en/latest/_static/chick-subset/chick-edgeR.csv>`__
and open in Excel; go ahead and do so.

As you can see, it's got the two columns with fold change and counts
per million; it's also got a P value and a FDR (false discovery rate) value
for each gene.  And, if you look at the first three rows, you'll see that
these are three rows that yield the red dots on the MA plot!  Hey, I wonder
what those genes are...

Well, here is where the XLOC gene names are perhaps not that useful :).
Let's go back and see if we can get any more information out of our
transcriptome...

Links:

* `edgeR tutorial from UT Austin <https://wikis.utexas.edu/display/bioiteam/Differential+gene+expression+analysis#Differentialgeneexpressionanalysis-Optional:edgeR>`__

Questions:

* Why does the MA plot have the shape that it does?

Transferring "official" gene names from the official transcriptome
------------------------------------------------------------------

If you look at :doc:`s-building-a-reference`, we used TopHat and
Cufflinks to build new gene models from our RNAseq, and then merged
the gene models with the already existing gene models from the
official annotation.  This gave us a file 'cuffmerge_all/nostrand.gtf'
which contained gene annotaions and the gene coordinates for exons;
from this, we extracted 'cuffmerge_all.fa', which contains a bunch
of FASTA sequences.  If you look at the top of *this* file, you'll
see that the FASTA sequence names look like this:

   >TCONS_00000001 gene=17.5

These 'TCONS' names are unique transcript identifiers; what we really want
are the gene names, though.  Unfortunately, we don't have TCONS, we have XLOC,
which are unique *gene* identifiers.  How do we turn those into gene names!?

If you look at cuffmerge_all/nostrand.gtf, ::

   head -1 cuffmerge_all/nostrand.gtf

you'll see lines that contain information like this::

   "XLOC_000001"; transcript_id "TCONS_00000002"; exon_number "1"; gene_name "17.5"; oId "NM_205429"; nearest_ref "NM_205429"; class_code "="; tss_id "TSS1"; p_id "P2";

There's the XLOC number, along with a bunch of other info! We want (at
least!) two pieces of information from this - the gene name (here '17.5') and
the nearest reference gene (here 'NM_205429').  How do we get those into
the same spreadsheet as the differentially expressed genes?

As with the R script above, this is a situation where a little bit of
scripting comes in handy - I've written a small Python script to do this,
`add-gene-name-to-diffexpr-csv.py <https://github.com/ngs-docs/2014-msu-rnaseq/blob/master/files/add-gene-name-to-diffexpr-csv.py>`__.

To download and run it, do::

   curl -O https://raw.githubusercontent.com/ngs-docs/2014-msu-rnaseq/master/files/add-gene-name-to-diffexpr-csv.py
   python add-gene-name-to-diffexpr-csv.py cuffmerge_all/nostrand.gtf chick-edgeR.csv > chick-edgeR-named.csv

You can `download my copy of this file <http://2014-msu-rnaseq.readthedocs.org/en/latest/_static/chick-subset/chick-edgeR-named.csv>`__ and open it in Excel, or you can just `look at it online <https://github.com/ngs-docs/2014-msu-rnaseq/blob/master/files/chick-subset/chick-edgeR-named.csv>`__

A quick note -- it's important to realize that we didn't do any clever
analysis to get the gene name and nearest reference gene information
into this file.  It was simply transferred from the official gene
annotation for chick when we ran cuffmerge.  We'll talk a little bit about
how to generate your own annotations later.

.. @CTB

Next: :doc:`m-advice`
