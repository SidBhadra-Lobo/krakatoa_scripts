#!/usr/bin/env perl

#Nextseq SampleSheet.csv Builder.

use strict;
use warnings;

my $dir = '/home/sbhadral/barcode_tables';

foreach my $fp (glob("$dir/*.csv")) {
    printf "%s\n", $fp;


# open .csv table.
open (my $fh_brcd, "<", $fp)
    or die "Can't open < dir/your_barcode.csv: $!";

    my %truseq; #initialize hash table 
    while (my $line=<$fh_brcd>) { # read lines in
        if($line !~ /IndexName/) { #ignores the header
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

}