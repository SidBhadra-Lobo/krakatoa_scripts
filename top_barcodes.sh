#!/bin/bash -l

#Get top barcodes from demultiplexed fastq.gz files.

# list=$(less /git/nextseq/processed/160929_0001/file_list.txt); #put path to directory holding demultiplexed reads.

for fastq in $(less /git/nextseq/processed/161013_0002/all_fastq_list.txt);

do
    name=$(echo "$fastq" | sed 's/^\/.*\///' );
    run_name=$(echo 161013_0002);
    dir_name=$(echo "$fastq" | sed 's/\(.*\)\/.*/\1/' | sed 's/.*\///' );
    

    zless "$fastq" | grep "^[ACGTN]*$" | head -100000 | sort | uniq -c | sort -nr -k 1,1 > /git/nextseq/processed/"$run_name"/"$dir_name"/"$name"_top_barcodes.txt;

done &