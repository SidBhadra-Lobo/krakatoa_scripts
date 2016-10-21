#!/bin/bash -l

#Nextseq Data Analysis Pipeline

#Currently, intended to process one sequencing run at a time.

# replace path to sequence run raw data location, likely /git/nextseq/<your run>/.
echo "Enter the desired run number (4 digits, like 0001), then press [ENTER]: ";
read run_number;

#write info in script to logfile.
echo "$run_number" >> /git/nextseq/processed/"$dir_name".logfile;
echo $d >> /git/nextseq/processed/"$dir_name".logfile;

echo "Enter '1' if want to convert trim and convert the fastqs->fasta, if not enter '0', then press [ENTER]: ";
read convert;

run=$(echo /git/nextseq/*_"$run_number"_*); #Change this to the path of desired sequencing run.

sample_count=$(less "$run"/SampleSheet.csv | grep test | wc -l); # sample sheet must be in Unix format (no DOS ^M characters).

dir_name=$(echo $run | sed 's/.*nextseq\///' | cut -f 1,3 -d_ );

d=$(date);

echo Starting demultiplexing. >> /git/nextseq/processed/"$dir_name".logfile;
echo $d >> /git/nextseq/processed/"$dir_name".logfile;


#Run illumina's bcl2fastq conversion tool. 
# -R for location of your run. nohup*.out is your bcl2fastq log file, '>' chooses a save location.
nohup /usr/local/bin/bcl2fastq -R "$run" -o /git/nextseq/processed/"$dir_name" -r 16 -d 16 -p 16 -w "$sample_count" > /git/nextseq/processed/nohup_"$dir_name".out 2>&1 &


#If the user wants to convert the fastq.gz files into fastas.
if [[ "$convert" == 1 ]]; 

then

    echo "Started fq->fa conversion and deduplication." >> /git/nextseq/processed/"$dir_name".logfile;
    echo $d >> /git/nextseq/processed/"$dir_name".logfile;

    #Get all Lane 1 Read 1 fastq files, not including "undetermined"
    ls /git/nextseq/processed/"$dir_name"/*_*/*L001*R1*.gz > /git/nextseq/processed/"$dir_name"/L1R1_list.txt;


    #loop through all L001_R1 files generated from demultiplexing.
    for fastq_file in $(less /git/nextseq/processed/"$dir_name"/L1R1_list.txt);

    do
        #get "name" for input in nextseq_gzip_mrg.pl
        name=$(echo "$fastq_file" | sed 's/_L001_R1_001.fastq.gz//' | sed 's/.*\///');

        #run nextseq_gzip_mrg.pl 
        /usr/bin/perl /home/sbhadral/scripts/nextseq_gzip_mrg.pl "$fastq_file" "$name" DNA 1 >> /git/nextseq/processed/"$dir_name".logfile 2>&1 &


    done;

fi;
