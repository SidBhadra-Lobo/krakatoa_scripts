#!/bin/bash -l
#Get percent RPKMS for TCR_HLA from th-express.org mouse database.


cd /Users/Sid/Girihlet_assignments/data/TCR_HLA_expression/Mus_musculus_RNA-Seq_read_counts_RPKM;

#remake individual files for each chain.

# grep ENSMUSG00000076928 M.musculus_TCR_bgee_db_table.csv > TRAC_line;

# grep ENSMUSG00000076490 M.musculus_TCR_bgee_db_table.csv > TRBC1_line;

# grep ENSMUSG00000076498 M.musculus_TCR_bgee_db_table.csv > TRBC2_line;

# grep ENSMUSG00000076749 M.musculus_TCR_bgee_db_table.csv > TRGC1_line;

# grep ENSMUSG00000076752 M.musculus_TCR_bgee_db_table.csv > TRGC2_line;

# grep ENSMUSG00000091682 M.musculus_TCR_bgee_db_table.csv > TRGC3_line;

# grep ENSMUSG00000076757 M.musculus_TCR_bgee_db_table.csv >TRGC4_line;


TRAC=12900;
TRBC1=4940;
TRBC2=10900;
TRGC1=12.7;
TRGC2=0.630;
TRGC3=0.458;
TRGC4=100000000; #actually is zero, but don't want to divide by zero.


for file in $(ls *line*);

do
	start=1;
	name=$(echo "$file" | sed 's/line//' );
	name_tot=$(echo "$file" | sed 's/_line//');
	count=$( wc -l "$file" | awk {'print $1'});

	for (( c=$start; c<=$count; c++ ));
	do
		echo "${!name_tot}" >> percent_rpkm/"$name"div_col; #dereferenced value within total values.
		echo "$name" >> percent_rpkm/"$name"exon_col;
		echo "Murine-Spleen" >> percent_rpkm/"$name"tissue_col;

	done;

	for line in "$file";

	do
		cut -f6 -d, "$line" >> percent_rpkm/"$name"rpkm_col;

	done;


		paste -d, percent_rpkm/"$name"rpkm_col percent_rpkm/"$name"div_col > percent_rpkm/"$name"2col; 

		paste -d, "$name"line percent_rpkm/"$name"tissue_col > percent_rpkm/"$name"intermediate1_col;

		paste -d, percent_rpkm/"$name"intermediate1_col percent_rpkm/"$name"exon_col > percent_rpkm/"$name"intermediate2_col;


	if [[ "$name" == "TRAC_" ]];
	then
	awk '{printf("%.4f\n", ($1/12900)*100)}' percent_rpkm/"$name"2col > percent_rpkm/test_TRAC_output.txt;

	echo "ExperimentID,GeneID,AnatomicalEntityName,StageName,ReadCount,RPKM,Total_RPKM_source_tissue,Exon,%RPKM," > percent_rpkm/new_Mus_musculus_RNA-Seq_read_counts_RPKM; #first time, use '>' in writing file.

	echo "#M.musculus_TRAC_expression_bgee_db," >> percent_rpkm/new_Mus_musculus_RNA-Seq_read_counts_RPKM; 

	paste -d, percent_rpkm/"$name"intermediate2_col percent_rpkm/test_TRAC_output.txt >> percent_rpkm/new_Mus_musculus_RNA-Seq_read_counts_RPKM;
fi;

	if [[ "$name" == "TRBC1_" ]];
	then
	awk '{printf("%.4f\n", ($1/4940)*100)}' percent_rpkm/"$name"2col > percent_rpkm/test_TRBC1_output.txt;

	echo "#M.musculus_TRBC1_expression_bgee_db," >> percent_rpkm/new_Mus_musculus_RNA-Seq_read_counts_RPKM;

	paste -d, percent_rpkm/"$name"intermediate2_col percent_rpkm/test_TRBC1_output.txt >> percent_rpkm/new_Mus_musculus_RNA-Seq_read_counts_RPKM;

fi;

	if [[ "$name" == "TRBC2_" ]];
	then
	awk '{printf("%.4f\n", ($1/10900)*100)}' percent_rpkm/"$name"2col > percent_rpkm/test_TRBC2_output.txt;

	echo "#M.musculus_TRBC2_expression_bgee_db," >> percent_rpkm/new_Mus_musculus_RNA-Seq_read_counts_RPKM;

	paste -d, percent_rpkm/"$name"intermediate2_col percent_rpkm/test_TRBC2_output.txt >> percent_rpkm/new_Mus_musculus_RNA-Seq_read_counts_RPKM;
fi;
	
	if [[ "$name" == "TRGC1_" ]];
	then
	awk '{printf("%.4f\n", ($1/12.7)*100)}' percent_rpkm/"$name"2col > percent_rpkm/test_TRGC1_output.txt;

	echo "#M.musculus_TRGC1_expression_bgee_db," >> percent_rpkm/new_Mus_musculus_RNA-Seq_read_counts_RPKM;

	paste -d, percent_rpkm/"$name"intermediate2_col percent_rpkm/test_TRGC1_output.txt >> percent_rpkm/new_Mus_musculus_RNA-Seq_read_counts_RPKM;

fi;
	if [[ "$name" == "TRGC2_" ]];
	then
	awk '{printf("%.4f\n", ($1/0.630)*100)}' percent_rpkm/"$name"2col > percent_rpkm/test_TRGC2_output.txt;

	echo "#M.musculus_TRGC2_expression_bgee_db," >> percent_rpkm/new_Mus_musculus_RNA-Seq_read_counts_RPKM;

	paste -d, percent_rpkm/"$name"intermediate2_col percent_rpkm/test_TRGC2_output.txt >> percent_rpkm/new_Mus_musculus_RNA-Seq_read_counts_RPKM;

fi;
	if [[ "$name" == "TRGC3_" ]];
	then
	awk '{printf("%.4f\n", ($1/0.458)*100)}' percent_rpkm/"$name"2col > percent_rpkm/test_TRGC3_output.txt;

	echo "#M.musculus_TRGC3_expression_bgee_db," >> percent_rpkm/new_Mus_musculus_RNA-Seq_read_counts_RPKM;

	paste -d, percent_rpkm/"$name"intermediate2_col percent_rpkm/test_TRGC3_output.txt >> percent_rpkm/new_Mus_musculus_RNA-Seq_read_counts_RPKM;

fi;
	if [[ "$name" == "TRGC4_" ]];
	then
	awk '{printf("%.4f\n", ($1/100000000)*100)}' percent_rpkm/"$name"2col > percent_rpkm/test_TRGC4_output.txt;

	echo "#M.musculus_TRGC4_expression_bgee_db," >> percent_rpkm/new_Mus_musculus_RNA-Seq_read_counts_RPKM;

	paste -d, percent_rpkm/"$name"intermediate2_col percent_rpkm/test_TRGC4_output.txt >> percent_rpkm/new_Mus_musculus_RNA-Seq_read_counts_RPKM;

fi;


done;

less percent_rpkm/new_Mus_musculus_RNA-Seq_read_counts_RPKM | sed 's/$/,/g' | sed 's/,,/,/g' | sed 's/present,//g' | sed 's/absent,//g' >> percent_rpkm/Mus_musculus_TCR_rpkms.csv;

rm -f percent_rpkm/*col;

