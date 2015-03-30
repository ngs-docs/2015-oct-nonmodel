# go to the working directory
cd /mnt/work

# now run Tophat!
tophat     -G cuffmerge_all/nostrand.gtf     --transcriptome-index=/mnt/genome/tophat/merged     -o tophat_male_repl1     /mnt/genome/Gallus_gallus/UCSC/galGal3/Sequence/Bowtie2Index/genome     male_repl1_R1.qc.fq.gz male_repl1_R2.qc.fq.gz

samtools sort -n tophat_male_repl1/accepted_hits.bam  tophat_male_repl1/accepted_hits.sorted && \
mv tophat_male_repl1/accepted_hits.sorted.bam tophat_male_repl1/accepted_hits.bam

htseq-count --format=bam --stranded=no --order=name     tophat_male_repl1/accepted_hits.bam     cuffmerge_all/nostrand.gtf > male_repl1_counts.txt

