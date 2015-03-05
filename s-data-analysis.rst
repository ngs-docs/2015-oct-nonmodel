Data analysis & differential expression
=======================================

At this point, you should have four files; if you type ``ls *.txt`` you should
see a list of files that includes these four files::

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
<https://github.com/ngs-docs/2015-mar-semimodel/blob/master/files/chick.R>`__.
This script will load in two samples with two replicates, execute an
MA plot, do an MDS analysis/plot, and provide a spreadsheet with
differential expression information in it.  To download it, `click
here
<http://2015-mar-semimodel.readthedocs.org/en/latest/_static/chick.R>`__.

Links:

* `False Discovery Rate <http://en.wikipedia.org/wiki/False_discovery_rate>`__
* `Learn R with Swirl <http://swirlstats.com/>`__
* `Data Carpentry <http://www.datacarpentry.org/>`__

Running edgeR on a data subset
------------------------------

.. note:: if you want to start from here on a fresh machine, you can do::

      mkdir /mnt/work

   and then run the 'curl' commands below, under "Running edgeR".

First, install R and edgeR::

   sudo apt-get install -y r-base-core r-bioc-edger

Now, to run the script on your Amazon computer, download the script
and data files for the 100k read subsets.  At the command line, do::

   cd /mnt/work
   curl -O http://2015-mar-semimodel.readthedocs.org/en/latest/_static/chick.R
   curl -O http://2015-mar-semimodel.readthedocs.org/en/latest/_static/chick-subset/female_repl1_counts.txt
   curl -O http://2015-mar-semimodel.readthedocs.org/en/latest/_static/chick-subset/female_repl2_counts.txt
   curl -O http://2015-mar-semimodel.readthedocs.org/en/latest/_static/chick-subset/male_repl1_counts.txt
   curl -O http://2015-mar-semimodel.readthedocs.org/en/latest/_static/chick-subset/male_repl2_counts.txt

These various .txt files are produced by :doc:`s-tophat-round2`, :doc:`s-more-tophat`, and :doc:`s-even-more-tophat`.

Next, to run the R script, do::

   Rscript chick.R

This will produce three files, `chick-edgeR-MA-plot.pdf
<http://2015-mar-semimodel.readthedocs.org/en/latest/_static/chick-subset/chick-edgeR-MA-plot.pdf>`__,
`chick-edgeR-MDS.pdf
<http://2015-mar-semimodel.readthedocs.org/en/latest/_static/chick-subset/chick-edgeR-MDS.pdf>`__,
and `chick-edgeR.csv
<http://2015-mar-semimodel.readthedocs.org/en/latest/_static/chick-subset/chick-edgeR.csv>`__;
they will be in your ``rnaseq`` folder in your home directory
on the HPC.  The CSV file can be opened directly in Excel; you can
also look at it `here
<https://raw.githubusercontent.com/ngs-docs/2015-mar-semimodel/master/files/chick-subset/chick-edgeR.csv>`__.
It consists of five columns: gene name, log fold change, P-value, and
FDR-adjusted P-value.

If you look closely at `the MA plot
<http://2015-mar-semimodel.readthedocs.org/en/latest/_static/chick-subset/chick-edgeR-MA-plot.pdf>`__,
you'll see that there are three red dots.  These are the genes with a
False Discovery Rate of 0.2 or less (see `chick.R
<https://github.com/ngs-docs/2015-mar-semimodel/blob/master/files/chick.R#L28>`__),
line 28.
Note that the axes on the MA plot are counts per million (CPM, X axis) and
fold change (Y axis).

Next, let's take a look at `chick-edgeR.csv
<https://github.com/ngs-docs/2015-mar-semimodel/blob/master/files/chick-subset/chick-edgeR.csv>`__.
This is a comma-separated value file that you can `download
<http://2015-mar-semimodel.readthedocs.org/en/latest/_static/chick-subset/chick-edgeR.csv>`__
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
`add-gene-name-to-diffexpr-csv.py <https://github.com/ngs-docs/2015-mar-semimodel/blob/master/files/add-gene-name-to-diffexpr-csv.py>`__.

To download and run it, do::

   curl -O https://raw.githubusercontent.com/ngs-docs/2015-mar-semimodel/master/files/add-gene-name-to-diffexpr-csv.py
   python add-gene-name-to-diffexpr-csv.py cuffmerge_all/nostrand.gtf chick-edgeR.csv > chick-edgeR-named.csv

You can `download my copy of this file <http://2015-mar-semimodel.readthedocs.org/en/latest/_static/chick-subset/chick-edgeR-named.csv>`__ and open it in Excel, or you can just `look at it online <https://github.com/ngs-docs/2015-mar-semimodel/blob/master/files/chick-subset/chick-edgeR-named.csv>`__.  And hey, look, gene names!

You can look up the NM_ stuff in genbank (actually, googling "genbank
NM_204286" will bring you right to a birdbase link), and the gene
names can be fed direclty into services like `DAVID
<http://david.abcc.ncifcrf.gov/tools.jsp>`__.

One quick note before we move on -- it's important to realize that we
didn't do any clever analysis to get the gene name and nearest
reference gene information into this file.  It was simply transferred
from the official gene annotation for chick when we ran cuffmerge.
We'll talk a little bit about how to generate your own annotations
later.

.. @CTB

Working with DAVID
------------------

When you're interested in looking at enrichment of functional gene
categories, the `DAVID tool for gene enrichment analysis
<http://david.abcc.ncifcrf.gov/tools.jsp>`__ is a common
recommendation.  The essential idea is to look at some selection of
genes (ones that are differentially expressed, usually!) in the
background context of a much larger set of genes (all expressed genes
that are not differentially expressed).

The simplest way to do this is to pick an FDR, and select all gene accessions
above that FDR.  For example:

* go to `DAVID <http://david.abcc.ncifcrf.gov/tools.jsp>`__;
* Select 'upload', and paste in the first 1,000 accessions from `chick-edgeR-named <http://2015-mar-semimodel.readthedocs.org/en/latest/_static/chick-subset/chick-edgeR-named.csv>`__;
* Under "Select identifier", choose "GENBANK_ACCESSION";
* Select "Gene List" for List Type;
* and then "Submit List".

  DAVID will now tell you that less than 80% of the list has mapped; that's
  expected, since there are a number of blank spots in the list.  Select
  "Continue to submit the IDs that DAVID could map."

* You should now be on Step 2. Select "Functional annotation tool."  Go
  to that link.

* Now, each of the three views (Clustering, Chart, and Table) will
  give you more information.

For me, under Clustering, Annotation Cluster 6 shows an enrichment of
sex-related genes, so I guess that's good, since we're comparing male
and female blastoderm gene expression from chick!  But this also
highlights the problems with this kind of analysis -- we can see what
we want!  Bear in mind that we are really looking more at the
background of *what genes are expressed* than what genes are
*differentially* expressed; to do the latter, we'd need to do a larger
analysis.

.. @CTB pathview: http://pathview.r-forge.r-project.org/pathview.pdf, http://pathview.r-forge.r-project.org/

.. Next: :doc:`s-data-analysis-2`
Next: :doc:`m-advice`
