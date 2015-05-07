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

   Transcript families and components are computational terms for
   "transcripts that may share exons".  The biological analogy to use
   is splice isoforms - but keep in mind that the computer can't
   necessarily tell the difference between transcripts that are "real"
   splice variants, noisy splicing, different allelic variants of
   transcripts, recent paralogs, etc. etc. - all the computer knows
   is that the transcripts share some amount of sequence.

   So, transcript families are Trinity's best guess at transcripts
   that come from the same locus.

3. What should we look at in FastQC results for RNAseq data?

   The main thing to pay attention to is the first graph, of quality
   scores vs position.  If your average quality takes a big dip at a
   particular position, you might consider trimming at that position.

4. How do we transfer our data to Amazon (or any remote computer)?

   There are two options --

   If your data is on your local computer, you can use Cyberduck to
   transfer the data to Amazon.  (see
   :doc:`n-interacting-with-amazon`).

   If the data is on a remote computer (like your sequencing center)
   you can probably use 'curl' or 'wget' to copy the data directly
   from the sequencing center to your Amazon computer.  You should ask
   them what the full URL (with username and password) is to each
   of your data sets, or find your local computer expert to help out.

5. How do we use Amazon to run full analyses?

   See :doc:`n-interacting-with-amazon`, "Running full analyses".

6. Can we use XSEDE or iPlant or <insert other platform here> to run these
   analyses?

   Yes, but you should omit all of the 'apt-get' and 'pip install'
   instructions - the sysadmins on those computers will need to install
   these programs for you.

7. How do we know if our reference transcriptome is "good enough"?

   See :doc:`remapping`.

8. How do I choose the set of tools to use?

   Our recommendations, in order:

   1. Find a tool that a nearby lab is using, and start there.

   2. Look at tools and workflows that are used in published papers by
      groups working in your area.

   3. Look for good tutorials online.
