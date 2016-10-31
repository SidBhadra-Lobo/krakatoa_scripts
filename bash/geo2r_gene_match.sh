#!/bin/bash -l

cd /Users/Sid/Documents/Girihlet_assignments/data

for gene in $(less gene_list.txt):

do
	 grep $gene p53_R175H_mutant_SKBR3_cells.txt | cut -f2- >> R175H_table.txt;
	 grep $gene p53_R273H_mutant_MDA-MB-468_cells.txt | cut -f2- >> R273H_table.txt;
	 
done

###\n