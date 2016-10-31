#!/bin/bash -l
#get names from col 1 for use in DAVID and FUNRICH

cd ../data/pathway_lists/;

for file in $(ls *.csv);

do
	name=$(echo "$file" | sed s/.csv/_col/ ) 
	cut -f1 -d, "$file" > "$name".txt;

done;