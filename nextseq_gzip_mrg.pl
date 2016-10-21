use strict;
use Symbol;

my $file1=shift;
my $name=shift;

my $mode="mRNA";

$mode="DNA";
$mode="mRNA";

$mode=shift;
my $trunc=shift;

my $host=`hostname`;

my $sort="sort ";

if($host=~/etna|lome/){
    $sort="sort -T /home/ravi/sort ";
    print STDERR "sort is now $sort\n";
#   my $com="cat @masters | sort --key=1,1  > $newmap/tbl_lane.master";
#my $com="cat @masters | sort -T /home/ravi/sort --key=1,1  > $newmap/tbl_lane.master";
} 

#die "Usage:$0 file name\nGive only the first file L001_R1 file and a name\n" if(!defined($name));

die "Usage:$0 file name mode(DNA|mRNA) truncate(0|1)\nGive only the first file L001_R1 file and a name\n" if(!defined($trunc));


my @F_files;
my @R_files;

my ($dir)=$file1=~/^(\S+)\/[^\/]+$/;

if($file1!~/L001/){
    if(!-e $file1){ die "$file1 is non-existent\n";}
    push(@F_files,$file1);
    if($file1=~/R1/){
	my $file2=$file1;$file2=~s/R1/R2/;
	if(-e $file2){ push(@R_files,$file2);}
    }
}
else  {
    for (my $i=0;$i<4;$i++){
	my $file=$file1;
	my $j=$i+1;
	$file=~s/_L001_/_L00$j\_/;

	my $rfile=$file;
	if($rfile !~/R1/){ die "$rfile does not have R1 in its name\n";}
	$rfile=~s/_R1_/_R2_/;

	if(-e $file){ push(@F_files,$file);}
#    else { die "why don't you have $file";}

	if(-e $rfile){ push(@R_files,$rfile);}
    }
}
my $pe=0;
if(@R_files>0) {$pe=1;}

print "mode=$mode, pe=$pe\n";

my $unfa="$dir/$name.unfa";
my $fa="$dir/$name.fa";
if(-e $fa ) { die  "STOP:$fa exists\n";}


my ($lenf,$lenr)=get_len_stats_pair($F_files[0],$R_files[0]);

print "done\n";

my $sublen=0;
my $prelen=0;
my $postlen=0;
if($mode eq "DNA"){
    if($lenf<75){
	$prelen=0;
	$postlen=0;
    }
    elsif($lenf>=75 && $lenf<84){
	$prelen=2;
	$postlen=2;
    }
    elsif($lenf>=84){
	$prelen=4;
	$postlen=4;
    }
    else {
	die "unhandled length\n";
    }
    if($trunc==0){	$prelen=0;	$postlen=0;    }
} elsif($mode eq "mRNA"){
    if($lenf>=50 && $lenf < 75){
	$prelen=2;
	$sublen=45;
    }
    elsif($lenf>=75 && $lenf < 84){
	$prelen=1;
	$sublen=37;
    }
    elsif($lenf>=84 && $lenf < 86){
	$prelen=2;
	$sublen=40;
    }
    elsif($lenf>=86 && $lenf < 98){
	$prelen=2;
	$sublen=42;
    }
    elsif($lenf>=98){
	$prelen=4;
	$sublen=45;
    }
    else {
	die "unhandled mRNA length\n";
    }
} else { die "unknown mode=$mode\n";}

print "$mode,prelen=$prelen, sublen=$sublen\n";

if(-e $unfa){ print "$unfa exists, so bypassing stuff\n";}
else{
    open OUT,">$unfa" or die "FAIL:$unfa";
    for(my $i=0;$i<@F_files;$i++){
	my $file=$F_files[$i];
	my $rfile;

	if($pe){ $rfile=$R_files[$i];}

	my $str=gensym();
	if($file=~/\.gz$/){ 	    open $str,"gunzip -c $file |";	}
	else { 	    open $str,"cat $file |";	}
	my $str2=gensym();
	if($pe){
	    if($rfile=~/\.gz$/){open $str2,"gunzip -c $rfile |";}
	    else{open $str2,"cat $rfile |";}
	}
	while(my $line1=<$str>){
	    chomp($line1);
	    my $line2=<$str>; chomp($line2);
	    my $line3=<$str>;chomp($line3);
	    my $line4=<$str>;chomp($line4);

	    my ($line5,$line6,$line7,$line8);
	    if($pe){
		$line5=<$str2>;
		$line6=<$str2>;
		chomp($line6);
		$line7=<$str2>;
		$line8=<$str2>;
		if(length($line6) >= $lenr){$line6=substr($line6,0,$lenr);}
		else { next;}

		$line6=~s/^\w{$prelen}// if($mode=~/mRNA/);

		if($mode=~/DNA/){
		    $line6=~s/^\w{$prelen}//;$line6=~s/\w{$postlen}$//;}
		$line6=rc($line6);
	    }


	    if(length($line2) >= $lenf){
		$line2=substr($line2,0,$lenf);
		$line2=~s/^\w{$prelen}// if($mode=~/mRNA/);
		if($mode=~/DNA/){
		    $line2=~s/^\w{$prelen}//;$line2=~s/\w{$postlen}$//;}
	    }else {
		next;
	    }
	    my @seq;
	    if($mode=~/mRNA/){
		@seq= $line2=~/(\w{$sublen})/g;

#		print "line2=$line2\n";
#		print "      12345678901234567890123456789012345678901234567890\n";
#		print join("\n",@seq)."\n";
		if($pe){
		    my @seq2=$line6=~/(\w{$sublen})/g;
		    push(@seq,@seq2);
		}
	    } else {
		if($pe){
		    push(@seq,$line2."N".$line6);
		} else {
		    push(@seq,$line2);
		}
	    }
	    print OUT join("\n",@seq)."\n";
	}
    }
}

close OUT;

#my $com="head -10000 $unfa | sort  | uniq -c |  sort -nr -k 1,1 | grep -v \"\\([ACGT]\\)\\1\\{12\\}\" | grep -v \"N\\{4\\}\" | sed 's/^ *\\([0123456789]*\\)/\.\\1/' | sed = | sed \"N;s/\\n//;s/^\\([0123456789]*\\)/>$name.\\1/\" |  sed 's/\\([0123456789]\\)  *\\([ACGTN]\\)/\\1\\n\\2/'  > $fa";

#my $com="cat $unfa | sort  | uniq -c |  sort -nr -k 1,1 | grep -v \"\\([ACGT]\\)\\1\\{12\\}\" | grep -v \"N\\{4\\}\" | sed 's/^ *\\([0123456789]*\\)/\.\\1/' | sed = | sed \"N;s/\\n//;s/^\\([0123456789]*\\)/>$name.\\1/\" |  sed 's/\\([0123456789]\\)  *\\([ACGTN]\\)/\\1\\n\\2/'  > $fa";

#my $com="cat $unfa | sort  | uniq -c |  sort -nr -k 1,1 | grep -v \"\\([ACGT]\\)\\1\\{12\\}\" | grep -v \"N\\{4\\}\" |  grep -v \"T\\{32\\}\" | grep -v \"A\\{32\\}\" | grep -v \"C\\{32\\}\" | grep -v \"G\\{32\\}\" | sed 's/^ *\\([0123456789]*\\)/\.\\1/' | sed = | sed \"N;s/\\n//;s/^\\([0123456789]*\\)/>$name.\\1/\" |  sed 's/\\([0123456789]\\)  *\\([ACGTN]\\)/\\1\\n\\2/'  > $fa";


my $com="cat $unfa | $sort  | uniq -c |  $sort -nr -k 1,1 | grep -v \"\\([ACGTN]\\)\\1\\{12\\}\" | sed 's/^ *\\([0123456789]*\\)/\.\\1/' | sed = | sed \"N;s/\\n//;s/^\\([0123456789]*\\)/>$name.\\1/\" |  sed 's/\\([0123456789]\\)  *\\([ACGTN]\\)/\\1\\n\\2/'  > $fa";

print "$com\n";

system($com)==0 or die "FAIL:$com";

print "DONE \n";

exit;

sub rc{
    my $str=shift;
    $str=reverse($str);
    $str=~tr/ACGTacgt/TGCAtgca/;
    return $str;
}



sub get_len_stats_pair{

    my $file1=shift;

    my $file2=shift;

#    print "get_len_stats_pair($file1,$file2)\n"; exit;

    my $len1=get_len_stats($file1);

    my $len2;
    if(defined($file2)){
	$len2=get_len_stats($file2);
    }
    return ($len1,$len2);
}

sub get_len_stats{
    my $file=shift;

#    print "get_len_stats($file\n"; exit;

    my $com="gunzip -c $file | head -100000 | grep \"^[ACGTN]*\$"."\" ";
    if($file!~/\.gz$/){
	$com="cat $file | head -100000 | grep \"^[ACGTN]*\$"."\" ";
    }
#    print "$com\n";
    my $str=`$com`;
    chomp($str);
    my %len;
    my $cnt=0;

    my @tmp=split(/\n/,$str);
    foreach my $line(@tmp){
	my $l=length($line);
	$cnt++;
#	print "$cnt,len=$l,$line\n";
	print "$cnt,len=$l,$line\n" if($cnt%100001==1);
	$len{$l}++;
    }
    my @lens=sort{$b <=> $a} keys %len;
#    print "lens=@lens\n";exit;
    my $last;
    my $max=0;
    for(my $i=0;$i<@lens;$i++){
	print "$lens[$i]\t".$len{$lens[$i]};
	$max=$len{$lens[$i]} if($max < $len{$lens[$i]});
	my $rat=$len{$lens[$i]}/$max;
	print " rat=$rat\n";
	if($rat < 0.2){	    last;	}
	$last=$lens[$i];
    }

    print "Truncating to $last from $lens[0]  give 3 if okay,  2 to suggest your own length\n";
    if(0){
	my $okay=<STDIN>;
	chomp($okay);
	if($okay == 3) { return $last;}
	elsif($okay == 2) {
	    print "give your length\n";
	    my $L=<STDIN>;chomp($L);
	    print "using $L as length give 3 to okay\n";
	    my $okay=<STDIN>;
	    chomp($okay);

	    if($okay != 3) { die "aborted\n";}
	    return $L;
	}else{
	    die "you aborted run";
	}
    }
    return $last;
}
