#!/bin/bash -l

#get read counts from demultiplexed fastqs.

# list=$(less /git/nextseq/processed/160929_0001/single_file_test.txt); #put path to directory holding demultiplexed reads.

<<<<<<< HEAD
for fastq in $(less /git/nextseq/processed/161013_0002/all_fastq_list.txt);

do
  { name=$(echo "$fastq" | sed 's/^\/.*\///' );

    run_name=$(echo 161013_0002);

    dir_name=$(echo "$fastq" | sed 's/\(.*\)\/.*/\1/' | sed 's/.*\///' );

    # paste file name, read counts (lines not starting with + or @, divided by 2.), and top barcodes for the current file.
    paste -d, <(echo "$name") <(zless "$fastq" | grep -v "^[@+]" | wc -l | awk '{print $1/2}') > /git/nextseq/processed/"$dir_name"/"$name"_read_counts.csv;

    # get top barcodes for each individual run.
    # zless "$fastq" | grep "^[ACGTN]*$" | head -100000 | sort | uniq -c | sort -nr -k 1,1  > /git/nextseq/processed/"$dir_name"/"$name"_top_barcodes.txt; 

} &
=======
for fastq in $(less /git/nextseq/processed/160929_0001/file_list.txt);

do
    name=$(echo "$fastq" | sed 's/^\/.*\///' );
    dir_name=$(echo "$fastq" | sed 's/\(.*\)\/.*/\1/' | sed 's/.*\///' );

    # paste file name, read counts (lines not starting with + or @, divided by 2.), and top barcodes for the current file.
    paste -d, <(echo "$name") <(zless "$fastq" | grep -v "^[@+]" | wc -l | awk '{print $1/2}') > /git/nextseq/processed/"$dir_name"/"$name"_read_counts.csv &

    # get top barcodes for each individual run.
    zless "$fastq" | grep "^[ACGTN]*$" | head -100000 | sort | uniq -c | sort -nr -k 1,1  > /git/nextseq/processed/"$dir_name"/"$name"_top_barcodes.txt &
>>>>>>> 7e804b43a40cfa2c2dd7da3ebdd254bdbb2e9286

done;

     