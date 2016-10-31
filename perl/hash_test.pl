#!/usr/bin/env perl

# Testing out hash table comparisons.

use strict;
use warnings;


my %hash1 = ( 'Jan' => 1 , 'Feb' => "abc" , 'Mar' => 3);
my %hash2 = ( 'Jan' => 85 , 'Feb' => 44 , 'Mar' => 3 , 'Apr' => 23);

# my %hash1 = ( 'IndexA' => 1 , 'IndexB' => "abc" , 'IndexC' => 3);
# my %hash2 = ( 'IndexA' => 4 , 'IndexB' => 5 , 'IndexC' => 5 , 'IndexD' => 7);



#Same key
foreach my $val1 (keys %hash1)
 {
      foreach my $val2 (keys %hash2)   {
             if($val1 eq $val2)        {
                 print $val1 . "\n"; 
                  }
                }
        }        

#Same Value
foreach my $val1 (values %hash1)
 {
      foreach my $val2 (values %hash2)   {
             if($val1 eq $val2)        {
                 print $val1 . "\n"; 
                  }
                }
        }   

#Same Key and Value
foreach my $val1 (keys %hash1)
 {
      foreach my $val2 (keys %hash2)   {
             if($val1 eq $val2 && $val1 =~ m/\d+/)         {
                  if($hash1{$val1} == $hash2{$val2}) {
                    print $val1; 
                      }
                  }
             if($val1 eq $val2 && $val1 =~ m/[A-za-z ]+/)          {
                  if($hash1{$val1} eq $hash2{$val2}) {
                    print $val1; 
                      }   
                  }  
                }
        }