Counting the reads that map to each gene
========================================

Now that we know which reads go with which gene, we'll use
`HTSeq <http://www-huber.embl.de/users/anders/HTSeq/doc/overview.html>`__

First, load the PySAM and HTSeq software packages::

   module load PySAM/0.6
   module load HTSeq/0.6.1

And next, run HTSeq::

   htseq-count --format=bam --stranded=no --order=pos \
       tophat_out/accepted_hits.bam \
       /mnt/scratch/ctb/rna/Homo_sapiens/Ensembl/GRCh37/Annotation/Genes/genes.gtf > salivary_repl1_counts.txt

When this is done, type::

   less salivary_repl1_counts.txt

Questions:

* what are the 'ENS*...' names?
* what do these parameters mean?
* what parameters does HTSeq take?
* why are we using so many programs?

Links:

* `HTSeq <http://www-huber.embl.de/users/anders/HTSeq/doc/overview.html>`__

Next: :doc:`m-more-tophat`
