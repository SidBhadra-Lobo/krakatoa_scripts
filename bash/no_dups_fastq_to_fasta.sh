#!/bin/bash -l
#Sid
#Convert fastq to fasta, while removing duplicate lines.
#Sample files are Illumina 1.5 phred score, according to fastQC. (Check encoding using phred table or fastQC)

#Change to directory with zipped fastqs.
cd /Users/Sid/Girihlet_assignments/data/TCR_HLA_expression/TCR_bam_fastq/mouse_fastqs;

fastq_list=$(ls *test*.fastq.gz); #get list of fqs

#loop through zipped fq files and get names
for file in "$fastq_list";
do 
	name=$(echo "$file" | sed 's/.fastq.gz//'); #get name of file without extension

	#build fasta
	for line in $(zless "$file"); # open with zless to avoid gunzipping big files
	do
		header=$(echo "$line" | grep -v "^[ATCGN]&&[ATCGN]$" | grep "^@.*:"); #get the header for Illumina 1.3+
		read=$(echo "$line" | grep "^[ATCGN]&&[ATCGN]$"); #the following line (read)

		echo "$header" >> "$name".fa; # will have each line in the output.fa as: header[_space_] read
		echo "$read" >> "$name".fa
	done;

# 	#awk '!seen[$0]++' "$name".tandem.fa >> "$name".nodups.fa ; # remove duplicate lines, any line with both the same header AND read will be deleted.

# 	#this is place holder code, will build the final fasta a better way ( edit in place without needing a intermediate file)
# 	for cols in $(less "$name".nodups.fa);
# 	do
# 		echo "$cols" | cut -f1 >> "$name".fa;
# 		echo "$cols" | cut -f2 'd' >> "$name".fa;

# 	done;

# 	#rm -f "$name".tandem.fa;

done;

## better than my script.

zcat input_file.fastq.gz | awk 'NR%4==1{printf ">%s\n", substr($0,2)}NR%4==2{print}' > output_file.fa