#!/usr/bin/env perl

#Nextseq SampleSheet.csv Builder.

use strict;
use warnings;

# open .csv table.
open (my $fh_brcd, "<", "/home/sbhadral/barcode_tables/truseq_dna_meth_barcodes.csv")
    or die "Can't open < your_barcode.csv: $!";

my %truseq; #initialize hash table 
while (my $line=<$fh_brcd>) { # read lines in
    chomp $line;
    print $line,"\n";

    my ($word1, $word2) = split /,/, $line;

    $truseq{$word1} = $word2;
}

while ( my ($key, $val) = each %truseq) {
    print "Key $key => $val\n"
}


close($fh_brcd) || warn "close failed: $!";