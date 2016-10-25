#!/bin/bash -l

#Nextseq Data Analysis Pipeline

#Currently, intended to process one sequencing run at a time.

#get usage information
if [ "$1" == "-h" ]; then
  echo "Usage: `basename $0` [Use this script to demultiplex nextseq data using bcl2fastq (enter run number) then choose if you want to convert the fastq files to fasta (enter 1 or 0)]"
  exit 0
fi

# replace path to sequence run raw data location, likely /git/nextseq/<your run>/.
echo "Enter the desired run number (4 digits, like 0001), then press [ENTER]: ";
read run_number;

echo "Enter '1' if want to convert the fastqs->fasta, if not enter '0', then press [ENTER]: ";
read convert;

echo "Enter '1' if want trim the fastqs->fasta, if not enter '0', then press [ENTER]: ";
read trunc;

#write info in script to logfile.
echo run number: "$run_number" converted: "$convert" truncated: "$trunc" >> /git/nextseq/processed/"$dir_name".logfile;
echo $d >> /git/nextseq/processed/"$dir_name".logfile;

run=$(echo /git/nextseq/*_"$run_number"_*); #Change this to the path of desired sequencing run.

sample_count=$(less "$run"/SampleSheet.csv | grep test | wc -l); # sample sheet must be in Unix format (no DOS ^M characters).

dir_name=$(echo $run | sed 's/.*nextseq\///' | cut -f 1,3 -d_ );

d=$(date);

####COMMENT OUT IF YOU WANT TO ONLY DO CONVERSION######
# echo Starting demultiplexing. >> /git/nextseq/processed/"$dir_name".logfile;
# echo $d >> /git/nextseq/processed/"$dir_name".logfile;


# #Run illumina's bcl2fastq conversion tool. 
# # -R for location of your run. nohup*.out is your bcl2fastq log file, '>' chooses a save location.
# nohup /usr/local/bin/bcl2fastq -R "$run" -o /git/nextseq/processed/"$dir_name" -r 16 -d 16 -p 16 -w "$sample_count" > /git/nextseq/processed/nohup_"$dir_name".out 2>&1 &

# #wait for demultiplex to finish before conversion.
# wait;
####COMMENT OUT IF YOU WANT TO ONLY DO CONVERSION######


#If the user does not want conversion and truncation of fastq.gz files.
if [[ "$convert" == 0 ]]; then 

    exit;

fi;

#If the user wants to convert the fastq.gz files into fastas and truncate.
if [[ "$convert" == 1 ]]; 

then

    echo "Started fq->fa conversion and deduplication." >> /git/nextseq/processed/"$dir_name".logfile;
    echo $d >> /git/nextseq/processed/"$dir_name".logfile;

    #Get all Lane 1 Read 1 fastq files, not including "undetermined"
    ls /git/nextseq/processed/"$dir_name"/*_*/*hs_mt*L001*R1*.gz > /git/nextseq/processed/"$dir_name"/L1R1_"$dir_name"_list.txt;


    #loop through all L001_R1 files generated from demultiplexing.
    for fastq_file in $(less /git/nextseq/processed/"$dir_name"/L1R1_"$dir_name"_list.txt);

    do

        #get "name" for input in nextseq_gzip_mrg.pl
        name=$(echo "$fastq_file" | sed 's/_L001_R1_001.fastq.gz//' | sed 's/.*\///');

        #If the user does not want to truncate.
        if [[ "$trunc" == 0 ]]; then 

            #run nextseq_gzip_mrg.pl without truncation.
            /usr/bin/perl /home/sbhadral/scripts/nextseq_gzip_mrg.pl "$fastq_file" "$name" DNA "$trunc" >> /git/nextseq/processed/"$dir_name".logfile 2>&1 &


        fi;

        #If the user wants to truncate.
        if [[ "$trunc" == 1 ]]; then
            
            #run nextseq_gzip_mrg.pl with truncation.
            /usr/bin/perl /home/sbhadral/scripts/nextseq_gzip_mrg.pl "$fastq_file" "$name" DNA "$trunc" >> /git/nextseq/processed/"$dir_name".logfile 2>&1 &

        fi;
        
    done;

fi;

####\n