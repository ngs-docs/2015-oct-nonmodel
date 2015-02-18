Data analysis 2: more sequence fu
=================================

In :doc:`s-data-analysis`, we talked about using existing annotations,
transferred to your new gene models from the primary gene models.
What if you want to annotate any new genes (genes that weren't in the
original annotation)?

This is much more technically challenging, and the pipeline doesn't
work entirely on the HPC just yet.  Here are some tips to get started.

Running TransDecoder to turn transcripts into ORFs
--------------------------------------------------

::

   module load TransDecoder
   TransDecoder.LongOrfs -t cuffmerge_all.fa

   curl -O https://raw.githubusercontent.com/ngs-docs/2014-msu-rnaseq/master/files/remove-stop-codon.py
   python remove-stop-codon.py cuffmerge_all.fa.transdecoder_dir/longest_orfs.pep > cuffmerge_orfs.pep
   
Running InterProScan (iprscan)
------------------------------

::

   module load iprscan
   # interproscan.sh cuffmerge_orfs.pep

(The last command doesn't work yet!)

Next: :doc:`m-advice`
