#!/bin/bash -l

#Run Illumina's bcl2fastq file format conversion tool.

nohup /usr/local/bin/bcl2fastq -R /git/nextseq/161013_NB501739_0002_AHK7NFBGXY/ -o /git/nextseq/processed/161013_0002 -r 16 -d 16 -p 16 -w 13 > /git/nextseq/processed/nohup_161013_0002.out 2>&1 &