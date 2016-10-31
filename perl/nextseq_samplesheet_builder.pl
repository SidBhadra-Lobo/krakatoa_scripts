#!/usr/bin/env perl

#Nextseq SampleSheet.csv builder and barcode validator/generator.

use strict;
use warnings;
# use diagnostics; #will also change "die" messages with "uncaught exception"

use lib("/home/sbhadral");

use Class::CSV;

# open .csv table.
# NEED TO INCLUDE MORE BARCODES FOR HASH TABLE.
open (my $fh_brcd, "<", "/home/sbhadral/barcode_tables/truseq_dna_meth_barcodes.csv")
    or die "Can't open < your_barcode.csv: $!";

my %barcodes; #initialize hash table 
while (my $line=<$fh_brcd>) { # read lines in

    if($line !~ /IndexName/i) { #ignores the header
    chomp $line;
    
    # print $line,"\n";

    my ($index, $seq) = split /,/, $line; #split index and seq by ','

    $barcodes{$index} = $seq; # assign val to key.
    }
}

    while ( my ($key, $val) = each %barcodes) { #check if keys are assigned correctly.
        print "Key $key => $val\n"
    }

#Ask user what they want to do.
print "Do you want to validate barcodes? Enter yes or no.\n";
chomp(my $valid= <STDIN>);
print "Do you want to build a samplesheet csv? Enter yes or no.\n";
chomp(my $build= <STDIN>);

#Check input.
if ( $valid =~ /yes/i) {
    &validator;
    print "Done with validation. \n";
}

if ( $build=~ /yes/i) {
    &build_csv;
    print "Done with csv build. \n";
}

if ($valid =~ /no/i and $build=~ /no/i) {
   die "You didn't choose yes to either option!";
}

if ( $build !~ /yes/i or $build !~ /no/i and $valid !~ /yes/i or $valid !~ /no/i) {
die "You didn't choose yes or no to either option!";
}


#Function to check single barcodes entered against a hash database.
sub validator {

  # print "How many samples do you have?\n";
  # print "Enter in the number and database.\n";

  print "Enter a barcode sequence to check. Type 'done' when all your barcodes are entered. \n";
  
  while (1) {
     
      chomp(my $brcd_seq = <STDIN>); 

      if ($brcd_seq =~ /^done/i) {
        last;
      }
      # print "You entered $brcd_seq.\n";

          my %revhash = reverse %barcodes; #get keys from value using reversed hash.

      if( exists $revhash{$brcd_seq} ) { # check barcode give index if valid.

          print "Your barcode sequence is valid. ";
          print "The barcode index: ";
          # my %revhash = reverse %barcodes;
          my $key_check = $revhash{$brcd_seq};
          print $key_check."\n"; 
      }
      else { print "Your barcode does not exist within this database.\n";
        # RUN >2 MISMATCH CHECK;
      #   print "Functionality in progress: But if it has >2 mismatches against all the barcodes you've entered, then it will still work.\n";
      }

      if(length($brcd_seq) < 6) {
          print "Your barcode seems too short (less than 6 bp): $brcd_seq\n";
      }
      if($brcd_seq !~ /[ATCG]/i) {
          print "Your barcode seems to not be made of standard nucleotides: $brcd_seq\n";
      }

  }
}

#Build csv, with user input.
# NEED TO ADD DUAL INDEX FUNCTIONALITY.
# LAST, ADD INPUT CHECKS.
sub build_csv {

    print "Now, to build the sample sheet, default values are already set. \n";
    # NUM: while (1) {
    #   print "Enter the run number as a single integer (ex. 4 or 5 ): \n";
    #   chomp(my $run_num = <STDIN>);
      
    #   if ($run_num !~ qw/[0-9]{1}/) {
    #         print "Please enter a valid run number. \n";
    #         redo NUM;
    #       }
    #   last;    
    # }
    print "Enter the run number as a single integer (ex. 4 or 415 ): \n";
    chomp(my $run_num = <STDIN>);
    print "Enter the date as mm/dd/yy (ex. 10/25/16) : \n";
    chomp(my $date = <STDIN>);
    print "Enter the run description delimited by underscores (ex. your_samp_description) : \n";
    chomp(my $descp = <STDIN>);
    print "Enter the read length for the forward read as an integer (ex. 151) : \n";
    chomp(my $read1 = <STDIN>);
    print "Enter the read length for the reverse read as an integer (ex. 0, if SingleEnd) : \n";
    chomp(my $read2 = <STDIN>);  

      my $csv = Class::CSV->new(
        fields => [qw/Sample_ID Sample_Name Sample_Plate Sample_Well I7_Index_ID index Sample_Project Description/] # This is for the [Data] section of the csv, even though the columns over lap with other sections.
      );

      #Build header and settings section info.
      $csv->add_line(['[Header]']);
      $csv->add_line(['IEMFileVersion', 4]);
      $csv->add_line(['ExperimentName', "Run_$run_num"]); # Need to get rid of double quotes that show up on Experiment Name and pass variable properly.
      $csv->add_line(['InvestigatorName', 'AnithaJayaprakash']);
      $csv->add_line(['Date', "$date"]);
      $csv->add_line(['Workflow', 'GenerateFASTQ']);
      $csv->add_line(['Application', 'NextSeqFASTQOnly']);
      $csv->add_line(['Assay', 'TruSeqHT']);
      $csv->add_line(['Description', "$descp"]);
      $csv->add_line(['Chemistry', 'Default']);
      $csv->add_line(['']);
      $csv->add_line(['[Reads]']);
      $csv->add_line(["$read1"]);
      $csv->add_line(["$read2"]);
      $csv->add_line(['[Settings]']);
      $csv->add_line(['']);

      #Build data section.
      $csv->add_line(['[Data]']);
      $csv->add_line(['Sample_ID', 'Sample_Name', 'Sample_Plate', 'Sample_Well', 'I7_Index_ID', 'index', 'Sample_Project', 'Description']);
      $csv->add_line({
        Sample_ID => 'sampleblah',
        Sample_Name => 'sample2name',
        Sample_Plate => 'test',
        Sample_Well => 'test',
        I7_Index_ID => "A00what",
        # index => "$brcd_seq",
        index => "index#",
        Sample_Project => 'sampleproject',
        Description => "$descp"
      });

    $csv->print();

}

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