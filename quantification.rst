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

    curl -L http://bio.math.berkeley.edu/eXpress/downloads/express-1.5.1/express-1.5.1-linux_x86_64.tgz > express.tar.gz

Align Reads with Bowtie
-----------------------
   
Next, build an index file for your assembly::

    gunzip trinity-nematostella-raw.renamed.fasta.gz
    bowtie-build --offrate 1 trinity-nematostella-raw.renamed.fasta trinity-nematostella-raw.renamed
    
Using the index we built, we'll align the reads from our first sample back to our assembly::

    bowtie -aS -X 800 --offrate 1 trinity-nematostella-raw.renamed -1 <(zcat 0Hour_ATCACG_L002_R1_001.extract.fastq.gz) -2 <(zcat 0Hour_ATCACG_L002_R2_001.extract.fastq.gz) > 0Hour_ATCACG_L002_001.extract.sam

Quantify Expression using eXpress
---------------------------------

Finally, using eXpress, we'll get abundance estimates for our transcripts::

    ~/express-1.5.1-linux_x86_64/express --no-bias-correct -o 0Hour_ATCACG_L002_001.extract.sam-express trinity-nematostella-raw.renamed.fasta 0Hour_ATCACG_L002_001.extract.sam

This will put the results in a new folder called <>. It contains a file called `results.xprs`, which we'll look at the first ten lines of using the `head` command::

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
