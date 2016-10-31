#!/bin/bash
#Ravi's code for removing adapters and fastq->fasta conversion.

cd /home/sbhadral/data/fastqs/mouse_fastqs;

#Tru-seq 3 adapters
# adap1=CTGTAGGCACCATCAATC
# adap1_p=CTGTAGG
adap1=AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC
adap1_p=AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTA

#no N
files=(
ENCFF001LEU.fastq.gz
ENCFF001LEX.fastq.gz
)
names=(
LEU
LEX
)
for (( i = 0 ; i < ${#files[@]} ; i++ )) do
  file=${files[$i]}
  name=${names[$i]}
  echo "$name $i $file"

  gunzip -c /home/sbhadral/data/fastqs/mouse_fastqs/$file  | grep '^[ACGTN]*$' | grep -e $adap1_p | sed -e "s/^\([ACGTN]*\)$adap1_p[ACGTN]*/\1/" | grep -e '[ACGTN]\{15,\}' |   sort | uniq -c | sort -nr -k 1,1 | sed 's/^ *\([0123456789]*\)/\.\1/' | sed = | sed "N;s/\n//;s/^\([0123456789]*\)/>$name.\1/" | sed 's/\([0123456789]\)  *\([ACGTN]\)/\1\n\2/'  > /home/sbhadral/data/fastqs/mouse_fastqs/$name.fa
done

# adap2=CTGTAGGCACCATCAATC
# adap2_p=CTGTAeGG
# files=(
# 5a2_Undetermined_S0_L001_R1_001.fastq.gz
# Adapter5a2_S1_L001_R1_001.fastq.gz
# )
# names=(
# N_Std_few
# N_Std
# )
# # These also need to also have the FIRST 5 nucleotides trimmed off. So
# #here,
# # trim the adapter and take all sequences that are over 20nts, trim the
# # FIRST 5nts (A,T,C,G,N) off
# for (( i = 0 ; i < ${#files[@]} ; i++ )) do
#   file=${files[$i]}
#   name=${names[$i]}
#   echo "$name $i $file"

#   gunzip -c data/$file  | grep '^[ACGTN]*$' | grep -e $adap2_p | sed -e "s/^\([ACGTN]*\)$adap2_p.*/\1/" | grep -e '[ACGTN]\{20,\}' |   sed -e "s/^[ACGTN]\{5\}\([ACGTN]*\)$/\1/" | sort | uniq -c | sort -nr -k 1,1 | sed 's/^ *\([0123456789]*\)/\.\1/' | sed = | sed "N;s/\n//;s/^\([0123456789]*\)/>$name.\1/" | sed 's/\([0123456789]\)  *\([ACGTN]\)/\1\n\2/'  > data/$name.fa
# done

# #exit 0

# adap3=AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC
# adap3_p=AGATCGG
# files=(
# 5-STD3-NNN_S1_L001_R1_001.fastq.gz
# )
# names=(
# Std_N
# )
# # For this library, you need to find this adapter, trim it off, take any
# # sequence over 20nts and then trim the LAST 5nts (A,T,C,G,N) off each
# # sequence.
# for (( i = 0 ; i < ${#files[@]} ; i++ )) do
#   file=${files[$i]}
#   name=${names[$i]}
#   echo "$name $i $file"

#   gunzip -c data/$file  | grep '^[ACGTN]*$' | grep -e $adap3_p | sed -e "s/^\([ACGTN]*\)$adap3_p.*/\1/" | grep -e '[ACGTN]\{20,\}' |   sed -e "s/^\([ACGTN]*\)[ACGTN]\{5\}$/\1/" | sort | uniq -c | sort -nr -k 1,1 | sed 's/^ *\([0123456789]*\)/\.\1/' | sed = | sed "N;s/\n//;s/^\([0123456789]*\)/>$name.\1/" | sed 's/\([0123456789]\)  *\([ACGTN]\)/\1\n\2/'  > data/$name.fa
# done

# # these libraries have the following 3' adapter sequence:
# # AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC
# #
# # 5-NNN3-NNN_S2_L001_R1_001.fastq--- NAME: N_N
# # DCR_S2_L001_R1_001.fastq--- NAME: Dcr2_-Wolb
# # DCR_S4_L001_R1_001.fastq--- NAME: Dcr2_+Wolb
# # DCRCYO_S1_L001_R1_001.fastq--- NAME: Dcr2CYO_-Wolb
# # DCRCYO_S3_L001_R1_001.fastq--- NAME: Dcr2CYO_+Wolb
# # For each of these libraries, you need to find this adapter, trim it off,
# # take any sequence over 25nts, and then trim off the FIRST AND LAST 5nts
# # (A,T,C,G,N) off each sequence.

# files=(
# 5-NNN3-NNN_S2_L001_R1_001.fastq.gz
# DCR_S2_L001_R1_001.fastq.gz
# DCR_S4_L001_R1_001.fastq.gz
# DCRCYO_S1_L001_R1_001.fastq.gz
# DCRCYO_S3_L001_R1_001.fastq.gz
# )
# names=(
# N_N
# Dcr2_m_Wolb
# Dcr2_p_Wolb
# Dcr2CYO_m_Wolb
# Dcr2CYO_p_Wolb
# )
# for (( i = 0 ; i < ${#files[@]} ; i++ )) do
#   file=${files[$i]}
#   name=${names[$i]}
#   echo "$name $i $file"
#   gunzip -c data/$file  | grep '^[ACGTN]*$' | grep -e $adap3_p | sed -e "s/^\([ACGTN]*\)$adap3_p.*/\1/" | grep -e '[ACGTN]\{25,\}' |   sed -e "s/^[ACGTN]\{5\}\([ACGTN]*\)[ACGTN]\{5\}$/\1/" | sort | uniq -c | sort -nr -k 1,1 | sed 's/^ *\([0123456789]*\)/\.\1/' | sed = | sed "N;s/\n//;s/^\([0123456789]*\)/>$name.\1/" | sed 's/\([0123456789]\)  *\([ACGTN]\)/\1\n\2/'  > data/$name.fa
# done




#cat $1 | grep '^[ACGTN]*$' | sort | uniq -c | sort -nr -k 1,1 | sed 's/^ *\([0123456789]*\)/\.\1/' | sed = | sed 'N;s/\n//;s/^\([0123456789]*\)/>\1/' | sed 's/\([0123456789]\) *\([ACGTN]\)/\1\n\2/' > $2.fa


