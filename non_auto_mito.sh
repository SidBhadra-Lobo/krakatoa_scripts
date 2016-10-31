#!/bin/bash -l
#mito non_auto script, also for testing.-

#Run a single sample test script.

# /usr/bin/perl /home/sbhadral/scripts/nextseq_gzip_mrg.pl /home/sbhadral/hs_mt_s2_e_di_gr_S6_L001_R1_001.fastq.gz hs_mt_s2_e_di_gr_S6 DNA 0 >> /home/sbhadral/hs_mt_s2_e_di_gr_S6.logfile 2>&1 &

# wait;

##USE nextseq_processing_alignment_pipeline.sh for the above.

# bash /home/sbhadral/mRNAseq/seq_code/mseek/sh/blast_hs_mt.sh >> /home/sbhadral/di_slva_q_vs_e.logfile 2>&1 &

# wait;
<<<<<<< HEAD
# already done hs_mt_s2_q_di_gr_S5hs_mt_s4_e_di_gr_S8

# names=(
=======

# names=(
# hs_mt_s2_q_di_gr_S5
# hs_mt_s4_e_di_gr_S8
>>>>>>> 7e804b43a40cfa2c2dd7da3ebdd254bdbb2e9286
# hs_mt_s4_q_di_gr_S7
# );

# for file in $names;

# do

# perl /home/sbhadral/mRNAseq/seq_code/mseek/bp_2_mut2.pl /home/sbhadral/mRNAseq/seq_code/mseek/mito_data_di/"$file".mt_hs.bp mt_hs /home/sbhadral/mRNAseq/seq_code/mseek/mito_data_di >> /home/sbhadral/di_slva_q_vs_e.logfile 2>&1 &

# done;

#Making it run more than one.

<<<<<<< HEAD
# already done hs_mt_o10_di_gr_S5 hs_mt_o11_di_gr_S6 hs_mt_o12_di_gr_S7 hs_mt_o5_di_gr_S1 hs_mt_o6_di_gr_S2 hs_mt_o7_di_gr_S3 hs_mt_o9_di_gr_S4 hs_mt_stvjksn_di_gr_S8
names=(
hs_mt_o6_di_gr_S2
);


# # reading array of names in might not be a good idea if an array already exists in blast_hs_mt.sh
# bash /home/sbhadral/mRNAseq/seq_code/mseek/sh/di2_blast_hs_mt.sh "${names[@]}" >> /home/sbhadral/di_slva.logfile 2>&1 &

# wait;

for file in "$names";
=======

names=(
hs_mt_o10_di_gr_S5
hs_mt_o11_di_gr_S6
hs_mt_o12_di_gr_S7
hs_mt_o5_di_gr_S1
hs_mt_o6_di_gr_S2
hs_mt_o7_di_gr_S3
hs_mt_o9_di_gr_S4
hs_mt_stvjksn_di_gr_S8
);


bash /home/sbhadral/mRNAseq/seq_code/mseek/sh/di2_blast_hs_mt.sh "${names[@]}" >> /home/sbhadral/di_slva.logfile 2>&1 &

wait;

for file in $names;
>>>>>>> 7e804b43a40cfa2c2dd7da3ebdd254bdbb2e9286

do

perl /home/sbhadral/mRNAseq/seq_code/mseek/bp_2_mut2.pl /home/sbhadral/mRNAseq/seq_code/mseek/mito_data_di/"$file".mt_hs.bp mt_hs /home/sbhadral/mRNAseq/seq_code/mseek/mito_data_di >> /home/sbhadral/di_slva.logfile 2>&1 &

done;