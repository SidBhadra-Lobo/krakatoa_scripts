#!/bin/bash -l

#Mito pipeline.

#Currently testing.

echo "Give the mito fastq path (/path/to/my/file), then press [Enter]: ";
read mito_path_in;

mito_path=$(echo "$mito_path_in" | sed 's/\/$//'); # remove trailing / if it exists.

dir="$mito_path";

if [ -d $dir ]; then
  echo "Directory exists, proceed.";
else
  echo "Directory does not exist, run program again."
  exit;
fi


echo "Give the name to use for the fasta converted file, then press [Enter]: ";
read name;

echo "Enter name of the organism to run (hs, mm, rn; only), then press [Enter]: ";
read org;

if [[ "$org" -ne 'hs' || "$org" -ne 'mm' || "$org" -ne 'rn' ]]; then
    #Wrong organism names.
    echo Not a valid organism name. Try again.
    exit;
fi

echo ...;
echo path chosen: "$mito_path";
echo name chosen: "$name";
echo organism chosen: "$org";

# blast_script=$(echo blast_"$org"_mt.sh);

# echo $blast_script;

#First convert fastq->fasta. (nextseq_gzip_mrg.pl DNA and trunc of 0)

mito_array=("$mito_path"/*.gz);

for file in $mito_array;
do
/usr/bin/perl /home/sbhadral/scripts/nextseq_gzip_mrg.pl "$file" "$name" DNA 0 >> "$mito_path"/"$name".logfile 2>&1 &
done;

wait;
#wait till fastqs are converted to fasta.

#Run mito blash_*_mt script.
if [[ "$org" == 'hs' ]]; then

echo Running blast against hs database;

# for names in $(echo "$mito_array");
# do

# running as blast_hs_mt.sh top db indir odir ext threads (no names yet).
bash /home/sbhadral/mRNAseq/seq_code/mseek/sh/blast_"$org"_mt.sh /home/sbhadral/mRNAseq/seq_code/mseek ref/mt_ref "$mito_path" "$mito_path" mt_"$org" 8 >> "$mito_path"/"$name".logfile 2>&1 &

# done;

else

echo Running blast against "$org" database;
bash /home/sbhadral/mRNAseq/seq_code/mseek/sh/blast_"$org"_mt.sh /home/sbhadral/mRNAseq/seq_code/mseek ref/mt_"$org" "$blast_path" "$blast_path"q mt_"$org" 8 >> "$mito_path"/"$name".logfile 2>&1 &

fi;

wait;

#WORKS UP TO HERE,  still need to get @names to be read in for blast @names.

