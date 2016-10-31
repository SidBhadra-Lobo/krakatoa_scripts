#!/bin/bash -l
# Align RNA-seq data to microbat refgen, meant to run on server.

# cd /home/sbhadral/data;

FILE=$(ls /home/sbhadral/data/fastqs/bat_fastqs/bat_tumorCellLine.fastq.gz)

#index ref, do only once.

bwa index /home/sbhadral/data/refgens/Myotis_lucifugus.Myoluc2.0.dna.toplevel.fa.gz

for file in $FILE;
do
    name=$(echo $file | sed 's/.*/bat_tumorCellLine/g' );

    bwa mem -M -t 32 -v 1 -p /home/sbhadral/data/refgens/Myotis_lucifugus.Myoluc2.0.dna.toplevel.fa.gz <(gunzip -dc "$file") | samtools view -bSh - > /home/sbhadral/data/alignments/bat_bams/"$name".bam;

    samtools flagstat /home/sbhadral/data/alignments/bat_bams/"$name".bam > /home/sbhadral/data/alignments/bat_bams/"$name".flagstat;

    samtools sort /home/sbhadral/data/alignments/bat_bams/"$name".bam > /home/sbhadral/data/alignments/bat_bams/"$name".sorted;

    samtools index /home/sbhadral/data/alignments/bat_bams/"$name".sorted;

done;