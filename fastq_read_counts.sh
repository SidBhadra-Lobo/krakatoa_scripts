#!/bin/bash -l

#get read counts from demultiplexed fastqs.

# list=$(less /git/nextseq/processed/160929_0001/single_file_test.txt); #put path to directory holding demultiplexed reads.

for fastq in $(less /git/nextseq/processed/160929_0001/file_list.txt);

do
    name=$(echo "$fastq" | sed 's/^\/.*\///' );
    dir_name=$(echo "$fastq" | sed 's/\(.*\)\/.*/\1/' | sed 's/.*\///' );

    # paste file name, read counts (lines not starting with + or @, divided by 2.), and top barcodes for the current file.
    paste -d, <(echo "$name") <(zless "$fastq" | grep -v "^[@+]" | wc -l | awk '{print $1/2}') > /git/nextseq/processed/"$dir_name"/"$name"_read_counts.csv &

    # get top barcodes for each individual run.
    zless "$fastq" | grep "^[ACGTN]*$" | head -100000 | sort | uniq -c | sort -nr -k 1,1  > /git/nextseq/processed/"$dir_name"/"$name"_top_barcodes.txt &

done;

     