#! /bin/bash
#PBS -l walltime=24:00:00,nodes=1:ppn=2,mem=10gb
#PBS -M titus@idyll.org
#PBS -A ged-intel11

cd $HOME/rnaseq/process
. env.sh

java -jar $TRIM/trimmomatic PE ERR315326_1.fastq ERR315326_2.fastq \
        lung_repl1_R1.qc.fq.gz s1_se lung_repl1_R2.qc.fq.gz s2_se \
        ILLUMINACLIP:$TRIM/adapters/TruSeq3-PE.fa:2:40:15 \
        LEADING:2 TRAILING:2 \
        SLIDINGWINDOW:4:2 \
        MINLEN:25

tophat -p 4 \
    -G ~/RNAseq-model/Homo_sapiens/Ensembl/GRCh37/Annotation/Genes/genes.gtf \
    --transcriptome-index=$HOME/RNAseq-model/transcriptome \
    -o tophat_lung_repl1 \
    ~/RNAseq-model/Homo_sapiens/Ensembl/GRCh37/Sequence/Bowtie2Index/genome \
    lung_repl1_R1.qc.fq.gz lung_repl1_R2.qc.fq.gz

htseq-count --format=bam --stranded=no --order=pos \
    tophat_lung_repl1/accepted_hits.bam \
    ~/RNAseq-model/Homo_sapiens/Ensembl/GRCh37/Annotation/Genes/genes.gtf > lung_repl1_counts.txt
