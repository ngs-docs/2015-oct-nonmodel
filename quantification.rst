Quantification and Differential Expression
==========================================

First, make sure you've downloaded all the original raw data::

    cd /mnt/data
    curl -O -L http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-non-2015-05-04/0Hour_ATCACG_L002_R1_002.extract.fastq.gz
    curl -O -L http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-non-2015-05-04/0Hour_ATCACG_L002_R1_003.extract.fastq.gz
    curl -O -L http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-non-2015-05-04/0Hour_ATCACG_L002_R1_004.extract.fastq.gz
    curl -O -L http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-non-2015-05-04/0Hour_ATCACG_L002_R1_005.extract.fastq.gz
    curl -O -L http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-non-2015-05-04/0Hour_ATCACG_L002_R2_002.extract.fastq.gz
    curl -O -L http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-non-2015-05-04/0Hour_ATCACG_L002_R2_003.extract.fastq.gz
    curl -O -L http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-non-2015-05-04/0Hour_ATCACG_L002_R2_004.extract.fastq.gz
    curl -O -L http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-non-2015-05-04/0Hour_ATCACG_L002_R2_005.extract.fastq.gz
    curl -O -L http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-non-2015-05-04/6Hour_CGATGT_L002_R1_001.extract.fastq.gz
    curl -O -L http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-non-2015-05-04/6Hour_CGATGT_L002_R1_002.extract.fastq.gz
    curl -O -L http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-non-2015-05-04/6Hour_CGATGT_L002_R1_003.extract.fastq.gz
    curl -O -L http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-non-2015-05-04/6Hour_CGATGT_L002_R1_004.extract.fastq.gz
    curl -O -L http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-non-2015-05-04/6Hour_CGATGT_L002_R1_005.extract.fastq.gz
    curl -O -L http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-non-2015-05-04/6Hour_CGATGT_L002_R2_001.extract.fastq.gz
    curl -O -L http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-non-2015-05-04/6Hour_CGATGT_L002_R2_002.extract.fastq.gz
    curl -O -L http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-non-2015-05-04/6Hour_CGATGT_L002_R2_003.extract.fastq.gz
    curl -O -L http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-non-2015-05-04/6Hour_CGATGT_L002_R2_004.extract.fastq.gz
    curl -O -L http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-non-2015-05-04/6Hour_CGATGT_L002_R2_005.extract.fastq.gz

...and link it in::

    cd /mnt/work
    ln -fs /mnt/data/*.fastq.gz .

Download Express
----------------

Now, get express::

    cd
    curl -L http://bio.math.berkeley.edu/eXpress/downloads/express-1.5.1/express-1.5.1-linux_x86_64.tgz > express.tar.gz
    tar xzf express.tar.gz

Align Reads with Bowtie
-----------------------
   
Next, build an index file for your assembly::

    cd /mnt/work
    gunzip -c trinity-nematostella-raw.renamed.fasta.gz > trinity-nematostella-raw.renamed.fasta
    bowtie-build --offrate 1 trinity-nematostella-raw.renamed.fasta trinity-nematostella-raw.renamed
    
Using the index we built, we'll align the reads from a few of our samples back to our assembly::

    bowtie -aS -X 800 --offrate 1 trinity-nematostella-raw.renamed \
        -1 <(zcat 0Hour_ATCACG_L002_R1_001.extract.fastq.gz) \
        -2 <(zcat 0Hour_ATCACG_L002_R2_001.extract.fastq.gz) \
        > 0Hour_ATCACG_L002_001.extract.sam

    bowtie -aS -X 800 --offrate 1 trinity-nematostella-raw.renamed -1 <(zcat 0Hour_ATCACG_L002_R1_002.extract.fastq.gz) -2 <(zcat 0Hour_ATCACG_L002_R2_002.extract.fastq.gz) > 0Hour_ATCACG_L002_002.extract.sam

    bowtie -aS -X 800 --offrate 1 trinity-nematostella-raw.renamed -1 <(zcat 6Hour_CGATGT_L002_R1_001.extract.fastq.gz) -2 <(zcat 6Hour_CGATGT_L002_R2_001.extract.fastq.gz) > 6Hour_CGATGT_L002_001.extract.sam
    bowtie -aS -X 800 --offrate 1 trinity-nematostella-raw.renamed -1 <(zcat 6Hour_CGATGT_L002_R1_002.extract.fastq.gz) -2 <(zcat 6Hour_CGATGT_L002_R2_002.extract.fastq.gz) > 6Hour_CGATGT_L002_002.extract.sam

Quantify Expression using eXpress
---------------------------------

Finally, using eXpress, we'll get abundance estimates for our transcripts. eXpress uses a probabilistic model to efficiently assign mapped reads to isoforms and estimate expression level (see `the website for additional details and relevant publications <http://bio.math.berkeley.edu/eXpress/overview.html>`__)::

    ~/express-1.5.1-linux_x86_64/express --no-bias-correct -o 0Hour_ATCACG_L002_001.extract.sam-express trinity-nematostella-raw.renamed.fasta 0Hour_ATCACG_L002_001.extract.sam
    ~/express-1.5.1-linux_x86_64/express --no-bias-correct -o 0Hour_ATCACG_L002_002.extract.sam-express trinity-nematostella-raw.renamed.fasta 0Hour_ATCACG_L002_002.extract.sam

    ~/express-1.5.1-linux_x86_64/express --no-bias-correct -o 6Hour_CGATGT_L002_001.extract.sam-express trinity-nematostella-raw.renamed.fasta 6Hour_CGATGT_L002_001.extract.sam
    ~/express-1.5.1-linux_x86_64/express --no-bias-correct -o 6Hour_CGATGT_L002_002.extract.sam-express trinity-nematostella-raw.renamed.fasta 6Hour_CGATGT_L002_002.extract.sam

This will put the results in a new set of folders named like `<condition>_<barcode>_L002_<replicate>.extract.sam-express`. Each contains a file called `results.xprs` with the results. We'll look at the first ten lines of one of the files using the `head` command::

    head 0Hour_ATCACG_L002_001.extract.sam-express/results.xprs

You should see something like this::

    bundle_id   target_id   length  eff_length  tot_counts  uniq_counts est_counts  eff_counts  ambig_distr_alpha   ambig_distr_beta    fpkm    fpkm_conf_low   fpkm_conf_high  solvable    tpm
    1   nema.id7.tr4    269 0.000000    0   0   0.000000    0.000000    0.000000e+00    0.000000e+00    0.000000e+00    0.000000e+00    0.000000e+00    F   0.000000e+00
    2   nema.id1.tr1    811 508.137307  1301    45  158.338092  252.711602  4.777128e+01    4.816246e+02    3.073997e+03    2.311142e+03    3.836852e+03    T   4.695471e+03
    2   nema.id2.tr1    790 487.144836  1845    356 1218.927626 1976.727972 1.111471e+02    8.063959e+01    2.468419e+04    2.254229e+04    2.682610e+04    T   3.770463e+04
    2   nema.id3.tr1    852 549.122606  1792    3   871.770849  1352.610064 5.493335e+01    5.818711e+01    1.566146e+04    1.375746e+04    1.756546e+04    T   2.392257e+04
    2   nema.id4.tr1    675 372.190166  1005    20  88.963433   161.343106  2.836182e+01    3.767281e+02    2.358011e+03    1.546107e+03    3.169914e+03    T   3.601816e+03
    3   nema.id62.tr13  2150    1846.657210 9921    9825    9919.902997 11549.404689    1.704940e+03    1.970774e+01    5.299321e+04    5.281041e+04    5.317602e+04    T   8.094611e+04
    3   nema.id63.tr13  406 103.720396  360 270 271.097003  1061.173959 1.934732e+02    1.567940e+04    2.578456e+04    2.417706e+04    2.739205e+04    T   3.938541e+04
    3   nema.id61.tr13  447 144.526787  6   0   0.000000    0.000000    2.246567e+04    2.246565e+10    3.518941e-08    0.000000e+00    1.296989e-03    T   5.375114e-08
    4   nema.id21.tr8   2075    1771.684102 2782    58  958.636395  1122.756883 1.223148e+02    2.476298e+02    5.337855e+03    4.749180e+03    5.926529e+03    T   8.153470e+03

Differential Expression
-----------------------

First, install R and edgeR::

    sudo apt-get install -y r-base-core r-bioc-edger csvtool

Now, we extract the columns we need from the eXpress outputs and convert it to the appropriate format::

    csvtool namedcol -t TAB target_id,est_counts 0Hour_ATCACG_L002_001.extract.sam-express/results.xprs | csvtool drop 1 -u TAB - > 0Hour_repl1_counts.txt
    csvtool namedcol -t TAB target_id,est_counts 0Hour_ATCACG_L002_002.extract.sam-express/results.xprs | csvtool drop 1 -u TAB - > 0Hour_repl2_counts.txt
    csvtool namedcol -t TAB target_id,est_counts 6Hour_CGATGT_L002_001.extract.sam-express/results.xprs | csvtool drop 1 -u TAB - > 6Hour_repl1_counts.txt
    csvtool namedcol -t TAB target_id,est_counts 6Hour_CGATGT_L002_002.extract.sam-express/results.xprs | csvtool drop 1 -u TAB - > 6Hour_repl2_counts.txt

We'll be using `edgeR
<http://www.bioconductor.org/packages/release/bioc/html/edgeR.html>`__
to do the basic differential expression analysis of our counts.

To run edgeR, you need to write a data loading and manipulation script
in R.  In this case, I've provided one -- `diff_exp.R
<https://github.com/ngs-docs/2015-may-nonmodel/blob/master/files/diff_exp.R>`__.
This script will load in two samples with two replicates, execute an
MA plot, do an MDS analysis/plot, and provide a spreadsheet with
differential expression information in it. 

Links:

* `False Discovery Rate <http://en.wikipedia.org/wiki/False_discovery_rate>`__
* `Learn R with Swirl <http://swirlstats.com/>`__

So, download the script::

    cd /mnt/work
    curl -O http://2015-may-nonmodel.readthedocs.org/en/latest/_static/diff_exp.R

Now we run the differential expression script with::

    Rscript diff_exp.R

This will produce three files, `nema-edgeR-MA-plot.pdf
<http://2015-may-nonmodel.readthedocs.org/en/latest/_static/nema-edgeR-MA-plot.pdf>`__,
`nema-edgeR-MDS.pdf
<http://2015-may-nonmodel.readthedocs.org/en/latest/_static/nema-edgeR-MDS.pdf>`__,
and `nema-edgeR.csv
<http://2015-may-nonmodel.readthedocs.org/en/latest/_static/nema-edgeR.csv>`__. The CSV file can be opened directly in Excel; you can
also look at it `here
<https://raw.githubusercontent.com/ngs-docs/2015-may-nonmodel/master/files/chick-subset/chick-edgeR.csv>`__.
It consists of five columns: gene name, log fold change, P-value, and
FDR-adjusted P-value.

You can also view more informative versions of these files generated from a different dataset: `chick-edgeR-MA-plot.pdf
<http://2015-mar-semimodel.readthedocs.org/en/latest/_static/chick-subset/chick-edgeR-MA-plot.pdf>`__, and
`chick-edgeR-MDS.pdf
<http://2015-mar-semimodel.readthedocs.org/en/latest/_static/chick-subset/chick-edgeR-MDS.pdf>`__.
