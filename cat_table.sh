#!/bin/bash -l
#cat kegg pathway data and label each subset based on source genelist.

cd /Users/Sid/Girihlet_assignments/data/pathway_lists/ribo;

for file in $(ls *enrich*);

do
	name=$(echo "$file" | sed 's/.txt/ment/');
	echo "$name", >> DAVID_enrich_table.txt;
	cut -f 1-3,5-6,10,13 "$file" | sed 's/, /:/g' | sed 's/ //g' | sed 's/[[:space:]]/,/g' | sed 's/$/,/g' >> DAVID_enrich_table.txt;

done;
###\n