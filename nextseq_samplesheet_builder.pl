#!/usr/bin/env perl

#Nextseq SampleSheet.csv Builder.

use strict;
use warnings;

# open .csv table.
open (my $fh_brcd, "<", "/home/sbhadral/barcode_tables/truseq_dna_meth_barcodes.csv")
    or die "Can't open < your_barcode.csv: $!";

my %truseq; #initialize hash table 
while (my $line=<$fh_brcd>) { # read lines in
    if($line !~ /IndexName/) {
    chomp $line;
    print $line,"\n";

    my ($word1, $word2) = split /,/, $line; #split index and seq by ','

    $truseq{$word1} = $word2; # assign val to key.
    }
}

while ( my ($key, $val) = each %truseq) { #check if keys are assigned correctly.
    print "Key $key => $val\n"
}


close($fh_brcd) || warn "close failed: $!";