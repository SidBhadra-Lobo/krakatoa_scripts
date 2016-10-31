#!/bin/bash -l
# Use blastdbs (two murine spleen rna-seq datasets) to align mouse TCR loci.

blastn -query /home/sbhadral/data/fastas/mouse_fastas/TCR_fastas/All_mouse_TCR_chains.fa -db ' "/home/sbhadral/data/fastas/mouse_fastas/blast_db_fastas/ENCFF001LEU.fa" "/home/sbhadral/data/fastas/mouse_fastas/blast_db_fastas/ENCFF001LEX.fa"' -outfmt 7 > /home/sbhadral/data/alignments/BLAST_alignments/mouse_double_rna-seq_db.out 

# blastn -query /home/sbhadral/data/fastas/mouse_fastas/TCR_fastas/All_mouse_TCR_chains.fa -db /home/sbhadral/data/fastas/mouse_fastas/blast_db_fastas/ENCFF001LEU.fa -outfmt 7 > /home/sbhadral/data/alignments/BLAST_alignments/mouse_LEU_rna-seq_db.out 

# blastn -query /home/sbhadral/data/fastas/mouse_fastas/TCR_fastas/All_mouse_TCR_chains.fa -db /home/sbhadral/data/fastas/mouse_fastas/blast_db_fastas/ENCFF001LEX.fa -outfmt 7 > /home/sbhadral/data/alignments/BLAST_alignments/mouse_LEX_rna-seq_db.out 