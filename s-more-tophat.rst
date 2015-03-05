Processing another sample with TopHat and HTSeq
===============================================

Rather typing all of this in - let's put this in a text file, so we can
run the TopHat and HTSeq commands all at once!  This is called a "script".

Type::

   cd /mnt/work
   cat > chick-tophat-2.sh <<EOF

and then paste this in::

   # go to the working directory
   cd /mnt/work

   # now run Tophat!
   tophat \
       -G cuffmerge_all/nostrand.gtf \
       --transcriptome-index=/mnt/genome/tophat/merged \
       -o tophat_female_repl2 \
       /mnt/genome/Gallus_gallus/UCSC/galGal3/Sequence/Bowtie2Index/genome \
       female_repl2_R1.qc.fq.gz female_repl2_R2.qc.fq.gz 

   htseq-count --format=bam --stranded=no --order=pos \
       tophat_female_repl2/accepted_hits.bam \
       cuffmerge_all/nostrand.gtf > female_repl2_counts.txt
       
   EOF

(Be sure to press the Enter or Return key after pasting this in!)  This is
`called a 'heredoc' <http://en.wikipedia.org/wiki/Here_document#Unix-Shells>`__
and it gives a way to write a shell script via copy-paste ;).

Next, type::

   bash chick-tophat-2.sh

This will run all of the commands in the file 'chick-tophat-2.sh'.

You can use the 'nano' editor to modify this file -- type::

   nano chick-tophat-2.sh

Next: :doc:`s-even-more-tophat`
