#!/usr/bin/perl
use strict;

use Tree;

our $VERSION = '1.2';

=head1 

 Dereplicate and remove redundant sequences with errors in fastq format dataset
 generate output files - such as outfile.consensus.fq and outfile.excluded.fq in fastq format

=cut

=head2   Change Log
12-08-2010   (v1.2)Organized the program/library paths
09-08-2010   (v1.2)Updated the header information in consensus output again
09-03-2010   (v1.2)Updated the header information in consensus output
09-01-2010   (v1.2)Merge all bad reads into one file in fastq format
08-31-2010   (v1.2)Output a consensus file in fastq format as well
08-26-2010   (v1.2)Added an option to remove reads containing high frequency Tri-mer and output them to *.trimer
07-19-2010   (v1.2)Improved the consensus correction part using entire read to rebuild the tree data structure
07-19-2010   (v1.0)Allow users to provide the starting position of key as optional option -p [key starting postion]
06-15-2010   (v1.0)Add the ability to handle the single end reads with auto-detection
	      Allow users to provide the size of key as optional option -k [hash key size]
06-05-2010   (v1.0)Check the keys to see whether they contain Ns. If they do, put the
	     sequences in a separate file and keep statistics.
06-04-2010   (v1.0)Created a tree structure to dereplicate fastq format sequence dataset
	     Each Tree produces one concensus sequence
05-25-2010   (v1.0) Received the initial version
=cut

# usage
my $USAGE_TXT = "Usage: perl $0\n";
$USAGE_TXT .=  "\t -i /path/to/file <Input file in fastq format>\n";
$USAGE_TXT .=  "\t -o /path/to/file <output file name>\n";
$USAGE_TXT .=  "\t [-k NNN] (hash key size, default key size is 16 for paired end reads and 32 for single end reads)(optional)\n";
$USAGE_TXT .=  "\t [-p NNN] (key starting position] default 0) (optional)\n";
$USAGE_TXT .=  "\t [-trimer NNN] (trimer threshold, ex: 0.8) (optional)\n";
$USAGE_TXT .=  "# This script dereplicates redundant reads (both single and paired end reads) in a given dataset using Tree structure and generates two output files in FASTQ format (outfile.consensus.fq and outfile.excluded.fq) \n";

&run(@ARGV);

sub run {	

my($infile, $outfile, $k, $p, $pe, $trimer) = processArgs(@_);
open(TAG, $infile) or die $!;
my %s;
my %c;
#my %q;
my %s_copy;
my %n;
my %nc;
my %trimers;
my %tri;
my $reads=0;
my $nreads=0;
my $trimer_sum;

if ($pe) {
	# Paired end reads
	while(my $h1=<TAG> and my $s1=<TAG> and my $h12=<TAG> and my $q1=<TAG> and my $h2=<TAG> and my $s2=<TAG> and my $h22=<TAG> and my $q2=<TAG>) {
		chomp($s1);  chomp($s2);
     		next unless(length($s1) == length($s2));
     		chomp($h1);  chomp($h2);
		chomp($h12); chomp($h22);
     		chomp($q1);  chomp($q2);
     		my $key = join('', (substr($s1,$p,$k), substr($s2,$p,$k)));
	 
		# Check trimers
		if ($trimer > 0) {
	  		#$h1 =~s/^@/\>/;  $h2 =~s/^@/\>/;
     	  		%trimers = ();
	  		my $trimer_threshold= (length($s1) -2)/3 *$trimer;
	  		for(my $i=0; $i<=(length($s1)-3); $i++) {
              			$trimers{substr($s1, $i, 3)}++;
           		}
	  		foreach ( sort{ $trimers{$b} <=> $trimers{$a} } (keys %trimers) ) {
	    			if ( $trimers{$_} > $trimer_threshold ) {
					$h1="$h1._HighTrimer"; $h2="$h2._HighTrimer";
					$tri{$s1} .= "$h1;$s1;$h12;$q1;$h2;$s2;$h22;$q2;";
					$trimer_sum++;
					goto ENDLOOP;
	    			} else {
					last;
	      			}
	  		}
			%trimers = (); # clear hash   
			for(my $i=0; $i<=(length($s2)-3); $i++) {
			$trimers{substr($s1, $i, 3)}++;
			}
			foreach ( sort{ $trimers{$b} <=> $trimers{$a} } (keys %trimers) ) {
				if ( $trimers{$_} > $trimer_threshold ) {
					$h1="$h1._HighTrimer"; $h2="$h2._HighTrimer";
					$tri{$s1} .= "$h1;$s1;$h12;$q1;$h2;$s2;$h22;$q2;";
					$trimer_sum++;
					goto ENDLOOP;
				} else {
					last;
				}
			}
		} #if

		if ( $key =~ /N+/){
			$h1="$h1._NNN"; $h2="$h2._NNN";
			$n{$key} .= "$h1;$s1;$h12;$q1;$h2;$s2;$h22;$q2;";
			$nc{$key} ++;
		} else { 
			$s{$key} .= "$s1,$s2;";
			#$q{$key} .= "$q1,$q2;";
			$c{$key} ++;
		}
		ENDLOOP:
  	}
} else {
	# Single end reads
  	while(my $h1=<TAG> and my $s1=<TAG> and my $h12=<TAG> and my $q1=<TAG>) {
     		chomp($h1); chomp($s1); chomp($h12); chomp($q1);
		my $key;
		my $seqlen = length($s1);
		if ($seqlen > $k) {
			$key = substr($s1,$p,$k);
		}else{
			$key = $s1;	
		}
		# Check trimers
		if ($trimer > 0) {
			# Tri-mer Checking
			#$h1 =~s/^@/\>/;
			my $trimer_threshold= ($seqlen -2)/3 *$trimer;
			%trimers = ();
			for(my $i=0; $i<=(length($s1)-3); $i++) {
				$trimers{substr($s1, $i, 3)}++;
			}
		
			foreach (sort{ $trimers{$b} <=> $trimers{$a} } (keys %trimers) ) {
				if ( $trimers{$_} > $trimer_threshold ) {
					$h1="$h1._HighTrimer";
					$tri{$s1} .= "$h1;$s1;$h12;$q1;";
					$trimer_sum++;
					goto ENDLOOP2;
				} 
				last;
			}
		}#if	

	if ( $key =~ /N+/) {
		$h1="$h1._NNN";
	   	$n{$key} .= "$h1;$s1;$h12;$q1;";
	   	$nc{$key} ++;
	} else { 
	   	$s{$key} .= "$s1;";
	   	#$q{$key} .= "$q1;";
	   	$c{$key} ++;
	}

	ENDLOOP2:
    } # while loop
}
close(TAG);

foreach ( keys %c ){
    	$reads += $c{$_};
}

foreach ( keys %nc ){
	$nreads += $nc{$_};
}

%s_copy = %s;
print "# of hash table:  " . keys( %s ) . "\n";
my $tree_counter;


#foreach my $j (sort{ $c{$b} <=> $c{$a} } (keys %c) ) {
foreach my $j  (keys %s) {
	next unless(exists $s_copy{$j} && $c{$j}>0);

	#print "Tree:", $j, " ", $c{$j}, "\n";
	# Create a tree root node
	my $tree =  Tree->new($j);

	delete $s_copy{$j};
	$tree_counter +=1;
	my $count = 0;
	my @nodes;
 	$nodes[0]= $tree;

   	while (1) {
   		 foreach my $node (@nodes) {
			my $tj=$node->value;	
			#print" node: ", " $tj ",  "\n";
			for(my $n=0; $n<length($tj); $n++) {
				foreach ('A','G','C','T') {
					next if(substr($tj,$n,1) eq $_);
					my $str = $tj;
					substr($str,$n,1,$_);
					next unless(exists $s_copy{$str});
					if( $c{$str}>0 ) {# one substitution
						$count +=1; 
						# Add a child node
						$node->add_child( Tree->new( $str ) );
						delete $s_copy{$str};
				
						$c{$j} += $c{$str};
						$s{$j} .= $s{$str};
						$c{$str} = 0;
					}
				}
			}
     		}
		my @treenodes = $tree->traverse($tree->LEVEL_ORDER);
		@nodes = splice(@treenodes, -$count);
		
		if ( $count == 0 ){ # if no more children 
			$tree->remove_child(@nodes);
			last;
		} else{
			$count = 0;
		}
    	}
}

open(my $fh, ">$outfile.consensus.fa");

foreach my $j (sort{ $c{$b} <=> $c{$a} } (keys %c) ) {
    	next unless($c{$j}>0);
    	my($r1,$r2);
   	if($c{$j}<2) {
		if ($pe) {
			($r1,$r2) = split(",", $s{$j});
		 	 chop($r2);
			 printConsensus( $fh, $j,  $c{$j}, 2, 1, $r1, $r2, $pe, 1);
		} 
		else {
			($r1,$r2) = split(";", $s{$j});
			 printConsensus( $fh, $j,  $c{$j}, 1, 1, $r1, $r2, $pe, 1);
		}
    	} else {
		my ($consensus, $subtree_counter, $cc) = getConsensusTest($s{$j});
		$tree_counter += $subtree_counter;   # $tree_counter is used for printing output. 
		my @subcluster_count;
		my $m=0;
		foreach (sort{ $$cc{$b} <=> $$cc{$a} } (keys %$cc) ) {
			last unless($$cc{$_}>0);
			$subcluster_count[$m++] = $$cc{$_};
		}
		my @tmpconsensus = split( ",|;",  $consensus);
		my $consensus_count = scalar(@tmpconsensus);

		my $k=0; #sequential counter to apear in header of consensus reads
		for (my $i=0; $i< $consensus_count; $i++){
			$r1 = $tmpconsensus[$i++];
			$r2 = ($i < $consensus_count)? $tmpconsensus[$i] : "";
			printConsensus( $fh, $j, $c{$j}, $consensus_count, $subcluster_count[$k], $r1, $r2, $pe, ++$k);
		}
	}

}
close($fh);

# Output consensus reads in fastq format
system( "fasta_to_fastq $outfile.consensus.fa $outfile.consensus.fq h");
unlink(<$outfile.consensus.fa>);

# Print reads whose keys contain "N"
open(N, ">$outfile.excluded.fq");
foreach my $j (sort{ $nc{$b} <=> $nc{$a} } (keys %nc) ) {
	next unless($nc{$j}>0);
	print N join("\n", split(";", $n{$j})), "\n"; 
}
close(N);

# Print reads containing high frequency trimers
if ($trimer >0) {
	open(TRI, ">$outfile.trimer");
	foreach my $j (keys %tri) {
		print TRI join("\n", split(";", $tri{$j})), "\n";
     	}
	close(TRI);
	system (" cat $outfile.trimer >> $outfile.excluded.fq ");
	unlink(<$outfile.trimer>);
	$trimer_sum *=2 if ($pe);
	print "# of reads which contain high frequency Tri-mer in the input file: ", $trimer_sum, "\n";
}

if ($pe) {
	$reads *= 2;
	$nreads *= 2;
	$tree_counter *= 2;
}

print "# of reads in the input file: ", ($reads+$nreads), "\n";
print "# of reads whose keys contain \"N\" in the input file: ", $nreads, "\n";


if ($pe) { 
	print "# of reads in the consensus file (paired reads): ", ($tree_counter), "(", ($tree_counter/2),")\n";
} else {
	print "# of reads in the consensus file (single reads): ", ($tree_counter), "\n";
}

my $derep_rate ="n/a";
$derep_rate = formatPerc(100*(1-(($tree_counter)/($reads+$nreads))));
print "% of replication: ", $derep_rate, "\%\n";
print "% of dereplication: ", formatPerc(100-$derep_rate), "\%\n";

}

#####################################################################################################
sub printConsensus {

	my ($file, $j, $total_count, $consenus_count, $sub_cluster, $r1, $r2, $pe, $num) = @_;
    	my $r2_num;
	my $tmp;
	$tmp=$num*2;

	if ($pe){	
		$total_count *=2;
	} else {
		$num = $tmp - 1;
		$r2_num = $tmp;
	}
		
    	print $file ">", $j, "_", $total_count, "_", $consenus_count, "_", $sub_cluster, "_", "$num", "/1\n$r1\n";

    	if ( length($r2) >0){
		if ($pe) {
			print $file ">", $j, "_", $total_count, "_", $consenus_count, "_", $sub_cluster, "_", "$num", "/2\n$r2\n";
		} 
		else {
			print $file ">", $j, "_", $total_count, "_", $consenus_count, "_", $sub_cluster, "_", "$r2_num", "/1\n$r2\n";
		}
    	}
}


# Use partial read as a key
sub getConsensusTest
{
	my $str = shift;
	my @cluster = split(";", $str);
	my @c;
	my @score;
	my @char;
	my %count1;
	
	for(my $j=0; $j<length($cluster[0]); $j++) {
		my %bases;
		for(my $i=0; $i<=$#cluster; $i++) {
		$bases{substr($cluster[$i],$j,1)}++;
		}
		my $k=0;
		my $sum =0;
		@score =();
	
		foreach my $base (sort{$bases{$b} <=> $bases{$a} } (keys %bases)) {
			$score[$k] = $bases{$base}; 
			$char[$k++] = $base;
			$sum += $bases{$base};
		}
		# Conditions to check for multiple consensus outputs
		if (  ($score[1] > 1 && $sum/$score[1] < 10) || ( $score[0] == $score[1] ) ){
			my ($consensus, $t_counter, $cc)  = BuildFullConsensusTree( \@cluster );
			return ($consensus, ($t_counter-1), $cc);  #
		} else {	
			$c[$j] = $char[0];
		}
	}
		my $consensus = join('', @c);
		$count1{1} = scalar(@cluster);
		return ($consensus, 0, \%count1);
}

# Use entire (paired) read as a key
sub BuildFullConsensusTree
{
	my( $cluster_reads ) = shift; 
	my %cc;
	my %seq;
	my $results;
	foreach my $key (@$cluster_reads) {
		$seq{$key} .= "$key;";
		$cc{$key} ++;
	}
	my %seq_copy = %seq;
	my $tree_counter = 0;

	foreach my $j ( sort{ $cc{$b} <=> $cc{$a} } (keys %cc) ) {
	  	next unless(exists $seq_copy{$j} && $cc{$j}>0);

		# Create a tree root node
		my $tree = Tree->new($j);
	
		delete $seq_copy{$j};
		$tree_counter +=1;
		my $count = 0;
		my @nodes;
		$nodes[0]= $tree;

		while (1) {
			foreach my $node (@nodes) {
				my $tj=$node->value;	
				#print" node: ", " $tj ",  "\n";
				for(my $n=0; $n<length($tj); $n++) {
					foreach ('A','G','C','T') {
					next if(substr($tj,$n,1) eq $_);
					my $str = $tj;
					substr($str,$n,1,$_);
					next unless(exists $seq_copy{$str});
						if( $cc{$str}>0 ) {# one substitution
							$count +=1; 
							# Add a child node
							$node->add_child( Tree->new( $str ) );
							delete $seq_copy{$str};
					
							$cc{$j} += $cc{$str};
							$seq{$j} .= $seq{$str};
							delete $seq{$str};
							$cc{$str} = 0;
						}
					}
				}
			}
			my @treenodes = $tree->traverse($tree->LEVEL_ORDER);
			@nodes = splice(@treenodes, -$count);
		
			if ( $count == 0 ){ # if no more children 
				$tree->remove_child(@nodes);
				last;
			}
			else{
				$count = 0;
			}
		}
	}

	foreach my $j (sort{ $cc{$b} <=> $cc{$a} } (keys %cc) ) {
		next unless($cc{$j}>0);
		if($cc{$j}<2) {
			$results .= $seq{$j};
		} else {
			$results .= getConsensusMajority($seq{$j});
			$results .= ";";
		}
	}

	return ($results, $tree_counter, \%cc);
}


sub formatPerc
{
	my ($num) = shift;
	return ($num eq "n/a") ? $num : sprintf("%.2f", $num);
}

# Took from fromat_reads.pm library 
# Looks at the sequence identifiers to determine if the given fastq file is single or paired end
# 	@param $fq - the fq file
# 	@returns - true if the fq is paired end, false otherwise
sub isPairedEnd($)
{
	my ($fq) = @_;
	open(IN, $fq) or die("Unable to open fq: $fq\n");
	my $is_paired_end = 0;
	if (defined(my $h1=<IN>) and defined(my $s=<IN>) and defined(my $h2=<IN>) and defined(my $q=<IN>) and 
		  defined(my $h1_b=<IN>) and defined(my $s_b=<IN>) and defined(my $h2_b=<IN>) and defined(my $q_b=<IN>)) {
		chomp($h1);
		chomp($h1_b);
		$is_paired_end = (($h1 =~ m/.+\/1$/) && (($h1_b =~ m/.+\/2$/))) ? 1 : 0;
	}
	close(IN);
	return $is_paired_end;
}

sub processArgs() 
{ # parse the command-line arguments
	my (@arguments) = @_;

	# check args
	my $in_file = "";
	my $out_file ="";
	my $k="";
	my $p="";
	my $trimer="";
	for (my $i = 0 ; $i < @arguments ; $i++) {
		my $argument = $arguments[$i];
		if ($argument eq '-i') {
			$in_file = $arguments[++$i];
		} elsif ($argument eq '-o') {
			$out_file = $arguments[++$i]; 
		} elsif ($argument eq '-k') {
			$k = $arguments[++$i];
		} elsif ($argument eq '-p') {
			$p = $arguments[++$i];
		} elsif ($argument eq '-trimer') {
			$trimer = $arguments[++$i];
		} elsif ($argument eq '-h') {
			die("$USAGE_TXT\n");
		} else {
			die("Incorrect argument: $argument\n$USAGE_TXT");
		}
	}
	length($in_file) != 0 || die "No input file provided.\n$USAGE_TXT\n";
	chomp($out_file);
	length($out_file) != 0 || die "No output file provided.\n$USAGE_TXT\n";

	#print version
	print "Version $VERSION\n";

	# determine if paired/single end
	my $pe = isPairedEnd($in_file);
	if ($pe){
	    print "Paired end reads\n";
	}else{
	    print "Single end reads\n";
	}
	if ($pe && (length($k) == 0)) {
	    $k =16;
	}
	if ($pe ==0 && (length($k) == 0)) {
	    $k =32;
	}
	if (length($p) == 0 ) {
	    $p=0;
	}
	if (length($trimer) == 0 ) {
	    $trimer=0;
	}

	return ($in_file, $out_file, $k, $p, $pe, $trimer);
}

################################################################################


sub getConsensusMajority
{
	my $str = shift;
	my @temp = split(";", $str);
	my @c;
	for(my $j=0; $j<length($temp[0]); $j++) {
		my %bases;
		for(my $i=0; $i<=$#temp; $i++) {
			$bases{substr($temp[$i],$j,1)}++;
		}
		foreach my $base ( sort{$bases{$b} <=> $bases{$a} } (keys %bases)) {
			$c[$j] = $base;
			last;
		}
	}
	my $consensus = join('', @c);
	return $consensus;
}
