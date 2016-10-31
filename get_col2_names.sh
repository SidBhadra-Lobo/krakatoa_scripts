#!/bin/bash -l
## Get the gene names from the panther**list_immuneBioProcess for Ebola bat mutants.

cd /Users/Sid/Girihlet_assignments/data/pathway_analysis/Ebola/panther_bioProcess_lists;


for dir in $(sed -n 1p dir_list.txt);
do 
	cd /Users/Sid/Girihlet_assignments/data/pathway_analysis/Ebola/panther_bioProcess_lists/"$dir";
	for file in $(ls panther*);
	do
		name=$(echo "$file" | sed 's/.txt/_col.txt/' );
		cut -f 2 "$file" | awk '!x[$0]++' > $name;

	done
done
