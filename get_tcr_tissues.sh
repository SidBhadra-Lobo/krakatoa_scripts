#!/bin/bash -l

cd /Users/Sid/Documents/Girihlet_assignments/data/TCR_HLA_expression/Homo_sapiens_RNA-Seq_read_counts_RPKM/

for file in $(less exp_list.txt);

do
	echo "$file"

	if [[ "$file" == "*TRG*" || "*TRD*" ]];

		then 
			echo "$file" | sed 's/_expression*//g' >> $file.tissues
			grep "colon" "$file" | cut -f 1,4,6,8-11  >> $file.tissues
			grep "leukocyte" "$file" | cut -f 1,4,6,8-11  >> $file.tissues
	fi;

	# if [[ "$file" == "*TRA*" || "*TRB*" ]];

	# 	then
	# 		grep -v "multi-cellular organism" "$file" >> $file.tissues
	# 		echo "done with TRA and TRB"
	# fi;

done


####\n