#!/bin/bash -l
#Get percent RPKMS for TCR_HLA from th-express.org mouse database.


cd /Users/Sid/Girihlet_assignments/data/TCR_HLA_expression/Mus_musculus_RNA-Seq_read_counts_RPKM;

# grep ENSMUSG00000076928 M.musculus_TCR_bgee_db_table.csv > TRAC_line;

# grep ENSMUSG00000076490 M.musculus_TCR_bgee_db_table.csv > TRBC1_line;

# grep ENSMUSG00000076498 M.musculus_TCR_bgee_db_table.csv > TRBC2_line;

# grep ENSMUSG00000076749 M.musculus_TCR_bgee_db_table.csv > TRGC1_line;

# grep ENSMUSG00000076752 M.musculus_TCR_bgee_db_table.csv > TRGC2_line;

# grep ENSMUSG00000091682 M.musculus_TCR_bgee_db_table.csv > TRGC3_line;

# grep ENSMUSG00000076757 M.musculus_TCR_bgee_db_table.csv >TRGC4_line;


# TRAC=$(grep ENSMUSG00000076928 M.musculus_TCR_bgee_db_table.csv | less);
TRAC=12900;
# TRBC1=$(grep ENSMUSG00000076490 M.musculus_TCR_bgee_db_table.csv | less);
TRBC1=11.4;
# TRBC2=$(grep ENSMUSG00000076498 M.musculus_TCR_bgee_db_table.csv | less);
TRBC2=10900;
# TRGC1=$(grep ENSMUSG00000076749 M.musculus_TCR_bgee_db_table.csv | less);
TRGC1=12.7;
# TRGC2=$(grep ENSMUSG00000076752 M.musculus_TCR_bgee_db_table.csv | less);
TRGC2=0.630;
# TRGC3=$(grep ENSMUSG00000091682 M.musculus_TCR_bgee_db_table.csv | less);
TRGC3=0.458;
# TRGC4=$(grep ENSMUSG00000076757 M.musculus_TCR_bgee_db_table.csv | less);
TRGC4=0.957;


for file in $(ls *line*);

do
	start=1;
	name=$(echo "$file" | sed 's/line//' );
	name_tot=$(echo "$file" | sed 's/_line//');
	count=$( wc -l "$file" | awk {'print $1'});

	# for line in "$file";

	# do
	# #echo "$line" >> logfile; 

	for (( c=$start; c<=$count; c++ ));
	do
		echo "${!name_tot}" >> test/"$name"div_col;

	done;

	for line in "$file";

	do
		cut -f6 -d, "$line" >> test/"$name"rpkm_col;

		paste -d, test/"$name"rpkm_col test/"$name"div_col > test/"$name"2col;

	done;

	#awk '{ tmp=($1)/($2) ; printf"%0.2f\n", tmp }' test/"$name"2col > test/test_output.txt;

	if [[ "$name" == "TRAC_" ]];
	then
	awk '{print ($1/12900)*100}' test/"$name"2col > test/test_TRAC_output.txt;

	paste -d, "$name"line <(echo ${!name_tot}) > test/paste_total_"$name"_cols.txt;

	echo "#M.musculus_TRAC_expression_bgee_db," > test/new_Mus_musculus_RNA-Seq_read_counts_RPKM; #first time, use > in writing file.

	paste -d, test/paste_total_"$name"_cols.txt test/test_"$name"output.txt >> test/new_Mus_musculus_RNA-Seq_read_counts_RPKM;

fi;

	if [[ "$name" == "TRBC1_" ]];
	then
	awk '{print ($1/11.4)*100}' test/"$name"2col > test/test_TRBC1_output.txt;

	paste -d, "$name"line <(echo ${!name_tot}) > test/paste_total_"$name"_cols.txt;

	echo "#M.musculus_TRBC1_expression_bgee_db," >> test/new_Mus_musculus_RNA-Seq_read_counts_RPKM;

	paste -d, test/paste_total_"$name"_cols.txt test/test_"$name"output.txt >> test/new_Mus_musculus_RNA-Seq_read_counts_RPKM;

fi;

	if [[ "$name" == "TRBC2_" ]];
	then
	awk '{print ($1/10900)*100}' test/"$name"2col > test/test_TRBC2_output.txt;

	paste -d, "$name"line <(echo ${!name_tot}) > test/paste_total_"$name"_cols.txt;

	echo "#M.musculus_TRBC2_expression_bgee_db," >> test/new_Mus_musculus_RNA-Seq_read_counts_RPKM;

	paste -d, test/paste_total_"$name"_cols.txt test/test_"$name"output.txt >> test/new_Mus_musculus_RNA-Seq_read_counts_RPKM;

fi;
	
	if [[ "$name" == "TRGC1_" ]];
	then
	awk '{print ($1/12.7)*100}' test/"$name"2col > test/test_TRGC1_output.txt;

	paste -d, "$name"line <(echo ${!name_tot}) > test/paste_total_"$name"_cols.txt;

	echo "#M.musculus_TRGC1_expression_bgee_db," >> test/new_Mus_musculus_RNA-Seq_read_counts_RPKM;

	paste -d, test/paste_total_"$name"_cols.txt test/test_"$name"output.txt >> test/new_Mus_musculus_RNA-Seq_read_counts_RPKM;

fi;
	if [[ "$name" == "TRGC2_" ]];
	then
	awk '{print ($1/0.630)*100}' test/"$name"2col > test/test_TRGC2_output.txt;

	paste -d, "$name"line <(echo ${!name_tot}) > test/paste_total_"$name"_cols.txt;

	echo "#M.musculus_TRGC2_expression_bgee_db," >> test/new_Mus_musculus_RNA-Seq_read_counts_RPKM;

	paste -d, test/paste_total_"$name"_cols.txt test/test_"$name"output.txt >> test/new_Mus_musculus_RNA-Seq_read_counts_RPKM;

fi;
	if [[ "$name" == "TRGC3_" ]];
	then
	awk '{print ($1/0.458)*100}' test/"$name"2col > test/test_TRGC3_output.txt;

	paste -d, "$name"line <(echo ${!name_tot}) > test/paste_total_"$name"_cols.txt;

	echo "#M.musculus_TRGC3_expression_bgee_db," >> test/new_Mus_musculus_RNA-Seq_read_counts_RPKM;

	paste -d, test/paste_total_"$name"_cols.txt test/test_"$name"output.txt >> test/new_Mus_musculus_RNA-Seq_read_counts_RPKM;

fi;
	if [[ "$name" == "TRGC4_" ]];
	then
	awk '{print ($1/0.957)*100}' test/"$name"2col > test/test_TRGC4_output.txt;

	paste -d, "$name"line <(echo ${!name_tot}) > test/paste_total_"$name"_cols.txt;

	echo "#M.musculus_TRGC4_expression_bgee_db," >> test/new_Mus_musculus_RNA-Seq_read_counts_RPKM;

	paste -d, test/paste_total_"$name"_cols.txt test/test_"$name"output.txt >> test/new_Mus_musculus_RNA-Seq_read_counts_RPKM;

fi;

	# percent=$( bc -l <<< <(less "$name"_rpkm_col))

	# echo "$percent" >> test_out.txt

	#echo assigned rpkm "$RPKM" and total "$Total" >> logfile;

# done;


done;


 



#rm -f test/TR*col;

# for i in "$RPKM";

# do
# 	#percent=$(echo $i/$TRAC_total*100 | bc -l);
	
# 	percent=$(bc -l <<< $i+100)
# 	#percent=$(echo $RPKM/$TRAC_total*100 | bc -l );

# 	#echo "$percent" percent rpkm found >> logfile;

# 	#new_cols=$(paste -s -d, <(echo "$Total") <(echo "$percent"));

# 	#echo assigned "$new_cols" >> logfile;

# 	#output=$(paste -s -d, <(echo "$line") <(echo "$new_cols"));

# 	#echo "$output" >> new_M.musculus_TCR_bgee_db_table.csv;

# 	#echo made file with "$output" >> logfile;

# 	# echo "$percent" >> test_out.txt #TRAC_rpkm_percent.txt;

# done;

# done;

# paste -d, TRAC_line TRAC_rpkm_percent.txt | sed 's/,,/,12900,/g' > TRAC_percent_rpkm.out;

# for line in <(echo "$TRBC1");

# do
# 	RPKM=$(cut -f6 -d, "$line");

# 	percent=$(echo "($RPKM/$TRBC1_total)*100" | bc -l );

# 	echo "$percent" >> TRBC1_rpkm_percent.txt;

# done;

# paste -d, TRBC1_line TRBC1_rpkm_percent.txt | sed 's/,,/,11.4,/g' > TRBC1_rpkm_percent.out;

# for line in <(echo "$TRBC2");

# do
# 	RPKM=$(cut -f6 -d, "$line");

# 	percent=$(echo "($RPKM/$TRBC2_total)*100" | bc -l );

# 	echo "$percent" >> TRBC2_rpkm_percent.txt;

# done;

# paste -d, TRBC2_line TRBC2_rpkm_percent.txt | sed 's/,,/,10900,/g' > TRBC2_rpkm_percent.out;

# for line in <(echo "$TRGC1");

# do
# 	RPKM=$(cut -f6 -d, "$line");

# 	percent=$(echo "($RPKM/$TRGC1_total)*100" | bc -l );

# 	echo "$percent" >> TRGC1_rpkm_percent.txt;

# done;

# paste -d, TRGC1_line TRGC1_rpkm_percent.txt | sed 's/,,/,12.7,/g' > TRGC1_rpkm_percent.out;


# for line in <(echo "$TRGC2");

# do
# 	RPKM=$(cut -f6 -d, "$line");

# 	percent=$(echo "($RPKM/$TRGC2_total)*100" | bc -l );

# 	echo "$percent" >> TRGC2_rpkm_percent.txt;

# done;

# paste -d, TRGC2_line TRGC2_rpkm_percent.txt | sed 's/,,/,0.630,/g' > TRGC2_rpkm_percent.out;

# for line in <(echo "$TRGC3");

# do
# 	RPKM=$(cut -f6 -d, "$line");

# 	percent=$(echo "($RPKM/$TRGC3_total)*100" | bc -l );

# 	echo "$percent" >> TRGC3_rpkm_percent.txt;

# done;

# paste -d, TRGC3_line TRGC3_rpkm_percent.txt | sed 's/,,/,0.458,/g' > TRGC3_rpkm_percent.out;

# for line in <(echo "$TRGC4");

# do
# 	RPKM=$(cut -f6 -d, "$line");

# 	percent=$(echo "($RPKM/$TRGC4_total)*100" | bc -l );

# 	echo "$percent" >> TRGC4_rpkm_percent.txt;

# done;

# paste -d, TRGC4_line TRGC4_rpkm_percent.txt | sed 's/,,/,0.957,/g' > TRGC4_rpkm_percent.out;


# ###once files are made and have the new, total rpkm and percent rpkm columns, concat all of them into one.
#cat *.out | sed 's/$/,/g' > out_concat.txt;

#rm -f *rpkm_percent*;
