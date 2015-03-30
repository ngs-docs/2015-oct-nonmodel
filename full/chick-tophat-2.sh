# go to the working directory
cd /mnt/work

# now run Tophat!
tophat     -G cuffmerge_all/nostrand.gtf     --transcriptome-index=/mnt/genome/tophat/merged     -o tophat_female_repl2     /mnt/genome/Gallus_gallus/UCSC/galGal3/Sequence/Bowtie2Index/genome     female_repl2_R1.qc.fq.gz female_repl2_R2.qc.fq.gz

samtools sort -n tophat_female_repl2/accepted_hits.bam  tophat_female_repl2/accepted_hits.sorted && \
mv tophat_female_repl2/accepted_hits.sorted.bam tophat_female_repl2/accepted_hits.bam

htseq-count --format=bam --stranded=no --order=name     tophat_female_repl2/accepted_hits.bam     cuffmerge_all/nostrand.gtf > female_repl2_counts.txt

