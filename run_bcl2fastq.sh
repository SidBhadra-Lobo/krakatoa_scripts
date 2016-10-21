#!/bin/bash -l

#Run Illumina's bcl2fastq file format conversion tool.

nohup /usr/local/bin/bcl2fastq -R /git/nextseq/161014* -o /git/nextseq/processed/run1_161014 -r 16 -d 16 -p 16 -w 13 &