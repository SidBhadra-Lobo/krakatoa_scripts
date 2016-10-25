#!/usr/bin/env perl

#Nextseq SampleSheet.csv Builder.

use strict;
use warnings;
use diagnostics;

# open .csv table.
open (my $fh_brcd, "<", "/home/sbhadral/barcode_tables/truseq_dna_meth_barcodes.csv")
    or die "Can't open < your_barcode.csv: $!";

my %barcodes; #initialize hash table 
while (my $line=<$fh_brcd>) { # read lines in
    if($line !~ /IndexName/) { #ignores the header
    chomp $line;
    print $line,"\n";

    my ($word1, $word2) = split /,/, $line; #split index and seq by ','

    $barcodes{$word1} = $word2; # assign val to key.
    }
}

    while ( my ($key, $seq) = each %barcodes) { #check if keys are assigned correctly.
        print "Key $key => $seq\n"
    }

#Function to check single barcodes entered.

# print "Do you want to check if a barcode sequence is valid?"
print "Enter a barcode sequence to check : \n";

chomp(my $brcd_seq = <STDIN>);

    print "You entered $brcd_seq.\n";

        my %revhash = reverse %barcodes;

    if( exists $revhash{$brcd_seq} ) {
        print "Your barcode sequence is valid.\n";
        print "Here is the barcode index: ";
        # my %revhash = reverse %barcodes;
        my $key = $revhash{$brcd_seq};
        print $key."\n"; 
    }
    if(length($brcd_seq) < 6) {
        print "Your barcode seems too short (less than 5 bp): $brcd_seq\n";
    }
    if($brcd_seq !~ /[ATCG]/) {
        print "Your barcode seems to not be made of standard nucleotides: $brcd_seq\n";
    }


# Check for duplicate barcodes when reading in multiple barcodes from list.
# my @keys = grep { $barcode{$_} eq $val } keys %barcodes; #check for duplicates

close($fh_brcd) || warn "close failed: $!";

#Get all csv files in a dir read into a hash, approach.

# use strict;
# use warnings;

# my $dir = '/home/sbhadral/barcode_tables'; #set up the dir with csv tables.

# foreach my $fp (glob("$dir/*.csv")) { # go through dir/*.csvs
#     printf "%s\n", $fp;

# # open .csv table.
# open (my $fh_brcd, "<", $fp)
#     or die "Can't open < dir/your_barcode.csv: $!";

#     my %truseq; #initialize hash table 
#     while (my $line=<$fh_brcd>) { # read lines in
#         if($line !~ /IndexName/) { #ignores the header
#         chomp $line;
#         print $line,"\n";

#         my ($word1, $word2) = split /,/, $line; #split index and seq by ','

#         $truseq{$word1} = $word2; # assign val to key.
#         }
#     }

#     while ( my ($key, $val) = each %truseq) { #check if keys are assigned correctly.
#         print "Key $key => $val\n"
#         }


# close($fh_brcd) || warn "close failed: $!";

# }