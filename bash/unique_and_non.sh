#!/bin/bash -l
# find non-unique and unique genes from the *immuneBioProcess tables generated from pantherdb.

cd /Users/Sid/Girihlet_assignments/data/pathway_lists/Ebola;

for file in $(cat *immuneBioProcess*);

do
	genes=$(echo '$file' | cut -f 2);

	echo '$genes' | sort -u >> unique_immune_genes.txt;

done;
