Semi-model organisms and RNAseq: an overview of the options
===========================================================

When you're performing RNAseq on a non-model system *with* a genome
but *without* a mature gene annotation or a mature functional
annotation, you have a few options.

1. You can use the official gene annotation.  Your analysis will then leave
   out any missing genes or unannotated genes, and your analysis will also
   be less sensitive to UTRs and may return incorrect results on incompletely
   annotated genes.

2. You can build your own gene models from your own (or others') data,
   merge them with the official gene models, and transfer annotations
   from the official gene models.  This will give you a more robust analysis
   by extending UTRs and improving gene models, but you may end up with
   "anonymous" (unannotated) genes that are differentially expressed.

3. You can build your gene models, merge them with the official gene models,
   and both transfer annotations from the official gene models *and*
   build your own annotations.  This is very time consuming but is probably
   the most sensitive!

Of these three options, the second is the one I most recommend for
RNAseq from organisms with an evolutionarily close model system (e.g.
all vertebrates).  A few reasons --

* the official gene annotation for the model system should be pretty good,
  and those annotations will have been transferred effectively to your
  organism;

* in particular, you're unlikely to be missing entire genes (as long as
  they're in the genome sequence, they will probably be annotated!);

* but you *may* be missing UTRs or exons in the official annotation for
  *your* organism - RNAseq is cheaper and higher resolution than most
  previous methods for gene discovery.

* you may also be missing important genes for the process you're
  studying, but if they are not in the model reference, they will be
  unknown and therefore under- or un-annotated anyway; you'll see them
  with differential expression but won't have any information on what
  they do. That's OK and expected, but there's very little
  bioinformatics can do for you - you'll need to put in the time and
  effort to characterize the gene experimentally.

So, the upshot from this is that you can *increase sensitivity* by building
your own gene models, but are probably ok without building your own
annotations.

