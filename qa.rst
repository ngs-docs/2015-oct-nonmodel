Miscellaneous questions
=======================

1. When should I use de novo assembly, and when should I use
   `reference-guided (ab initio) assembly
   <http://2015-mar-semimodel.readthedocs.org/en/latest/>`__?

   This is always a judgement call, and you can always try both
   (although there aren't good methods for comparing the results).

   The short version is that if you have no nearby genomic sequence,
   you *must* use de novo assembly; if you have an incomplete genomic
   sequence you *may* want to use de novo assembly; and if you have
   a great genomic sequence, you *shouldn't* use de novo assembly.

   The positives of using de novo assembly are that you do not depend
   in any way on the reference.  So, if the reference genome is missing,
   incomplete, or incorrect, you will not have biased results from doing
   it.

   The negatives are that you will get many more isoforms from de novo
   transcriptome assembly than you will from reference-based
   transcriptome assembly, and the process is probably a bit more
   computationally intensive (and certainly more subject to problems from
   bad data).

2. What are "transcript families"?

3. What should we look at in FastQC results for RNAseq data?

4. How do we transfer our data to Amazon (or any remote computer)?

5. How do we use Amazon to run full analyses?

6. Can we use XSEDE or iPlant or <insert other platform here> to run these
   analyses?

7. How do we know if our reference transcriptome is "good enough"?
