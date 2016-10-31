#!/usr/bin/env perl
#Get gene name col from csv files to use in DAVID and FUNRICH tools for Ebola bats.
use strict;

$^I = ".col1"

while (<>) {

	print $1 if /\A.+\s\b/;
}