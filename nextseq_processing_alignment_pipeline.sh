#!/bin/bash -l

#Nextseq Data Analysis Pipeline

#Currently, intended to process one sequencing run at a time.

# replace path to sequence run raw data location, likely /git/nextseq/<your run>/.
run=$(/git/nextseq/161013_NB501739_0002_AHK7NFBGXY/)

dir_name=$(echo $run | sed 's/\(.*\)\/.*/\1/' | sed 's/.*\///' | cut -f 1,3 -d_ )

d=$(date);

#write begining to script logfile.
echo Starting demultiplexing. >> /git/nextseq/processed/"$dir_name".logfile;
echo $d >> /git/nextseq/processed/"$dir_name".logfile;


#Run illumina's bcl2fastq conversion tool. 
# -R for location of your run. nohup*.out is your bcl2fastq log file, '>' chooses a save location.
nohup /usr/local/bin/bcl2fastq -R "$run" -o /git/nextseq/processed/"$dir_name" -r 16 -d 16 -p 16 -w 13 > /git/nextseq/processed/nohup_"$dir_name".out 2>&1 &


echo Done demultiplexing run. >> /git/nextseq/processed/"$dir_name".logfile;
echo $d >> /git/nextseq/processed/"$dir_name".logfile;

#Get all Lane 1 Read 1 fastq files, not including "undetermined"
L001_R1_list=$(ls /git/nextseq/processed/"$dir_name"/*_*/*L001*R1*.gz);


#loop through all L001_R1 files generated from demultiplexing.
for fastq_file in "$L001_R1_list";

do
    #get "name" for input in nextseq_gzip_mrg.pl
    name=$(echo "$fastq_file" | sed 's/_L001_R1_001.fastq.gz//');

    #run nextseq_gzip_mrg.pl
    #NOTE: Need a way to have user choose "DNA" and "truncate(0|1)" at beginning of script.n 
    /usr/bin/perl /home/sbhadral/scripts/nextseq_gzip_mrg.pl /git/nextseq/processed/"$dir_name"/*_*/"$fastq_file" "$name" DNA 1 >> /git/nextseq/processed/"$dir_name".logfile 2>&1 &

    echo Finished fq->fa conversion and deduplication. >> /git/nextseq/processed/"$dir_name".logfile;
    echo $d >> /git/nextseq/processed/"$dir_name".logfile;

done;
