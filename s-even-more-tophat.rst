Setting up more scripts
=======================

(If you're using an HPC or multiple computers, you can run these in
parallel; here, we'll just run them one at a time.)

Type::

   cat > chick-tophat-3.sh <<EOF

and then paste this in::

   # go to the 'rnaseq' directory in my home directory
   cd /mnt/work

   # now run Tophat!
   tophat \
       -G cuffmerge_all/nostrand.gtf \
       --transcriptome-index=/mnt/genome/tophat/merged \
       -o tophat_male_repl1 \
       /mnt/genome/Gallus_gallus/UCSC/galGal3/Sequence/Bowtie2Index/genome \
       male_repl1_R1.qc.fq.gz male_repl1_R2.qc.fq.gz 

   htseq-count --format=bam --stranded=no --order=pos \
       tophat_male_repl1/accepted_hits.bam \
       cuffmerge_all/nostrand.gtf > male_repl1_counts.txt
       
   EOF

Next, do it for male_repl2::

   cat > chick-tophat-4.sh <<EOF

and then paste this in::

   # go to the 'rnaseq' directory in my home directory
   cd /mnt/work

   # now run Tophat!
   tophat \
       -G cuffmerge_all/nostrand.gtf \
       --transcriptome-index=/mnt/genome/tophat/merged \
       -o tophat_male_repl2 \
       /mnt/genome/Gallus_gallus/UCSC/galGal3/Sequence/Bowtie2Index/genome \
       male_repl2_R1.qc.fq.gz male_repl2_R2.qc.fq.gz 

   htseq-count --format=bam --stranded=no --order=pos \
       tophat_male_repl2/accepted_hits.bam \
       cuffmerge_all/nostrand.gtf > male_repl2_counts.txt
       
   EOF

and then run them with::

   bash chick-tophat-3.sh
   bash chick-tophat-4.sh


Next: :doc:`s-data-analysis`
