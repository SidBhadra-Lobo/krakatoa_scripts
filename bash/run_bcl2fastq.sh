#!/bin/bash -l

#Run Illumina's bcl2fastq file format conversion tool.

<<<<<<< HEAD
nohup /usr/local/bin/bcl2fastq -R /git/nextseq/161013_NB501739_0002_AHK7NFBGXY/ -o /git/nextseq/processed/161013_0002 -r 16 -d 16 -p 16 -w 13 > /git/nextseq/processed/nohup_161013_0002.out 2>&1 &
=======
nohup /usr/local/bin/bcl2fastq -R /git/nextseq/161014* -o /git/nextseq/processed/run1_161014 -r 16 -d 16 -p 16 -w 13 &
>>>>>>> 7e804b43a40cfa2c2dd7da3ebdd254bdbb2e9286
