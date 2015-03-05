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

cufflinks produces transcripts, but many programs want protein sequences.
`TransDecoder <http://transdecoder.github.io>`__ will turn transcripts
into (predicted) peptide sequences::

   module load TransDecoder
   TransDecoder.LongOrfs -t cuffmerge_all.fa

   curl -O https://raw.githubusercontent.com/ngs-docs/2015-mar-semimodel/master/files/remove-stop-codon.py
   python remove-stop-codon.py cuffmerge_all.fa.transdecoder_dir/longest_orfs.pep > cuffmerge_orfs.pep

The file 'cuffmerge_orfs.pep' now contains entries that look like this::

    >TCONS_00000001|m.1 TCONS_00000001|g.1 type:complete len:173 gc:universal TCONS_00000001:696-1214(+)
    MCVPAWGLDQLNPLPQREVLGVQQSRQLRPLKEGDKSAVTDPIPGSSCQRCWALRAISVCWSPPISSTATLLFLVWTLPA
    VLLAVSQETQLLHCALKGGPLGVLTDQIPMVRLGVQLTITAADPWSCQDLEQRSQQCEHSTEQCCVPRGSAAIWCSRFPL
    DSAQFSPLTLLP

-- which is to say, protein sequences rather than DNA transcripts as in
cuffmerge_all.fa.

These can now be fed into `InterProScan <https://code.google.com/p/interproscan/wiki/Introduction>`__.
   
Running InterProScan (iprscan)
------------------------------

InterProScan will go through and integrate information from a number of
databases into an annotation of your sequences. ::

   module load iprscan
   # interproscan.sh -i cuffmerge_orfs.pep -f tsv

(The last command doesn't work yet on the HPC!)

This will give you output in a tab-delimited format, `cuffmerge_orfs.pep.tsv <https://github.com/ngs-docs/2015-mar-semimodel/blob/master/files/chick-subset/cuffmerge_orfs.subset.pep.tsv>`__.

This can then potentially be used to annotate any new genes with GO
terms and other putative functional annotation.

Next: :doc:`m-advice`
