Running digital normalization
=============================

Next, we're going to apply abundance normalization to the data --
known as "digital normalization", this approach was developed by our
lab to make it possible to assemble large data sets more quickly and
easily.  You can read more about it in `Brown et al., 2012
<http://arxiv.org/abs/1203.4802>`__, and also see some of its affects
on transcriptome assembly in `Lowe et al., 2014
<https://peerj.com/preprints/505/>`__.

Digital normalization works by eliminating high abundance reads that are
unnecessary for assembly.

First, we'll run it on the interleaved files we generated in the previous
section::

   cd /mnt/work
   normalize-by-median.py -k 20 -p -C 20 -N 4 -x 2e9 -s normC20k20.ct *.pe.qc.fq.gz

(These parameters should work for essentially all mRNAseq data sets; see
`the khmer documentation <http://khmer.readthedocs.org/en/v1.3/>`__ for more
information.)

Next, run diginorm on the orphaned reads (from trimming)::

   normalize-by-median.py -l normC20k20.ct -s normC20k20.ct orphans.fq.gz

Do k-mer abundance trimming on the reads, which will eliminate the majority
of the errors (thus further decreasing the memory requirements) --::

   filter-abund.py -V normC20k20.ct *.keep

See our paper `Zhang et al., 2014 <http://www.ncbi.nlm.nih.gov/pubmed/25062443`>`__, Table 3, for more information on k-mer trimming effects.

Now, take all of the paired-end files and split them into paired and
orphaned reads::

   for filename in *.pe.*.keep.abundfilt
   do
      extract-paired-reads.py $filename
   done

Put all the orphaned reads in one place::

   cat *.se orphans.fq.gz.keep.abundfilt | gzip > orphans.dn.fq.gz

And now rename the paired-end files to something nice::

   for filename in *.pe.qc.fq.gz.keep.abundfilt.pe
   do
      base=$(basename $filename .pe.qc.fq.gz.keep.abundfilt.pe)
      output=${base}.dn.fq.gz
      gzip -c $filename > $output
   done

Now, if you type::

   ls *.dn.fq.gz

you'll see all of the files that you need to move on to the next step -- ::

   0Hour_ATCACG_L002001.dn.fq.gz  6Hour_CGATGT_L002002.dn.fq.gz
   0Hour_ATCACG_L002002.dn.fq.gz  6Hour_CGATGT_L002003.dn.fq.gz
   0Hour_ATCACG_L002003.dn.fq.gz  6Hour_CGATGT_L002004.dn.fq.gz
   0Hour_ATCACG_L002004.dn.fq.gz  6Hour_CGATGT_L002005.dn.fq.gz
   0Hour_ATCACG_L002005.dn.fq.gz  orphans.dn.fq.gz
   6Hour_CGATGT_L002001.dn.fq.gz

Let's remove some of the detritus before moving on::

   rm *.pe *.se *.abundfilt *.keep
   rm normC20k20.ct

----
   
Next: :doc:`n-assemble`
