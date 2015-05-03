Running digital normalization
=============================

::

   normalize-by-median.py -k 20 -p -C 20 -N 4 -x 2e9 -s normC20k20.ct *.pe.qc.fq.gz

   filter-abund.py -V normC20k20.ct *.keep

   for filename in *.keep.abundfilt
   do
      extract-paired-reads.py $filename
   done

   normalize-by-median.py -k 20 -p -C 5 -N 4 -x 2e9 *.abundfilt.pe

   for filename in *.pe.qc.fq.gz.keep.abundfilt.pe.keep
   do
      base=$(basename $filename .pe.qc.fq.gz.keep.abundfilt.pe.keep)
      output=${base}.kak.fq.gz
      gzip -c $filename > $output
   done
