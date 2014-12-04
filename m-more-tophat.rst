Processing another sample with TopHat and HTSeq
===============================================

Let's script this!

Type::

   cat > lung-tophat.sh <<EOF

and then paste this in::

   module load Trimmomatic/0.32
   module load TopHat2/2.0.8b
   module load PySAM/0.6
   module load HTSeq/0.6.1

   cd ~/rnaseq

   gunzip -c /mnt/scratch/ctb/rna/ERR315326_1.fastq.gz | head -400000 | gzip > lung_repl1_R1.fq.gz
   gunzip -c /mnt/scratch/ctb/rna/ERR315326_2.fastq.gz | head -400000 | gzip > lung_repl1_R2.fq.gz

   java -jar $TRIM/trimmomatic PE lung_repl1_R1.fq.gz lung_repl1_R2.fq.gz \
     lung_repl1_R1.qc.fq.gz s1_se lung_repl1_R2.qc.fq.gz s2_se \
     ILLUMINACLIP:$TRIM/adapters/TruSeq2-PE.fa:2:40:15 \
     LEADING:2 TRAILING:2 \                            
     SLIDINGWINDOW:4:2 \
     MINLEN:25

   tophat -p 4 \
       -G /mnt/scratch/ctb/rna/Homo_sapiens/Ensembl/GRCh37/Annotation/Genes/genes.gtf \
       --transcriptome-index=/mnt/scratch/ctb/rna/transcriptome \
       -o tophat_lung_repl1 \
       /mnt/scratch/ctb/rna/Homo_sapiens/Ensembl/GRCh37/Sequence/Bowtie2Index/genome \
       lung_repl1_R1.qc.fq.gz lung_repl1_R2.qc.fq.gz 

   htseq-count --format=bam --stranded=no --order=pos tophat_lung_repl1/accepted_hits.bam \
       /mnt/scratch/ctb/rna/Homo_sapiens/Ensembl/GRCh37/Annotation/Genes/genes.gtf > lung_repl1_counts.txt
   EOF

(Be sure to press the Enter or Return key after pasting this in!)

And now type::

   bash lung-tophat.sh

This will run all of the commands in the file 'lung-tophat.sh'.

You can use the 'nano' editor to modify this fie -- type::

   nano lung-tophat.sh
