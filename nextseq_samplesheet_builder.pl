#!/usr/bin/env perl

#Nextseq SampleSheet.csv builder and barcode validator/generator.

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

    my ($index, $seq) = split /,/, $line; #split index and seq by ','

    $barcodes{$index} = $seq; # assign val to key.
    }
}

    while ( my ($key, $val) = each %barcodes) { #check if keys are assigned correctly.
        print "Key $key => $val\n"
    }

#Function to check single barcodes entered.

# print "Do you want to check if a barcode sequence is valid?"
print "Enter a barcode sequence to check : \n";

chomp(my $brcd_seq = <STDIN>);

    # print "You entered $brcd_seq.\n";

        my %revhash = reverse %barcodes; #get keys from value using reversed hash.

    if( exists $revhash{$brcd_seq} ) { # check barcode give index if valid.
        
        print "Your barcode sequence is valid.\n";
        print "Here is the barcode index: ";
        # my %revhash = reverse %barcodes;
        my $key_check = $revhash{$brcd_seq};
        print $key_check."\n"; 
    }
    if(length($brcd_seq) < 6) {
        print "Your barcode seems too short (less than 5 bp): $brcd_seq\n";
    }
    if($brcd_seq !~ /[ATCG]/) {
        print "Your barcode seems to not be made of standard nucleotides: $brcd_seq\n";
    }


#Start to build csv, trying to use Class::CSV.
# use Class::CSV;

# my $csv = Class::CSV->new(
#   fields         => [qw/Sample_ID Sample_Name Sample_Plate Sample_Well I7_Index_ID index Sample_Project Description/]
# );

# $csv->add_line(['sample1', 'sample1name', 'test', 'test', 'A044', 'TATAAT', 'project1', 'description1']);
# $csv->add_line({
#   Sample_ID   => 'sample2',
#   Sample_Name => 'sample2name'
# });

# $csv->print();

# Check for duplicate barcodes when reading in multiple barcodes from list.
# my @keys = grep { $barcode{$_} eq $val } keys %barcodes; #check for duplicates

close($fh_brcd) || warn "close failed: $!";

#Get all csv files in a dir read into a hash, approach.

# my $dir = '/home/sbhadral/barcode_tables'; #set up the dir with csv tables.

# foreach my $fp (glob("$dir/*.csv")) { # go through dir/*.csvs
#     printf "%s\n", $fp;

# # open .csv table.
# open (my $fh_brcd, "<", $fp)
#     or die "Can't open < dir/your_barcode.csv: $!";

# close($fh_brcd) || warn "close failed: $!";

# }