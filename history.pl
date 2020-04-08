#!/usr/bin/perl

use warnings;
use strict;
use File::Basename;
use Getopt::Long;
use List::MoreUtils qw( minmax );
my $prog=basename($0);
#use Cwd; #fuck you Cwd, I'm gonna use system commands

=comment
History Script
From the custom history file, 

=cut 

my $cwd;
my $long;
my $datenum=`echo \$DATENUM`; #relies on the environment variable called DATENUM
chomp $datenum;
my $date_limit;
my $help;
GetOptions ('-cwd'=>\$cwd,
			'-long'=>\$long,
			'-help'=>\$help,
			'-date:i'=>\$date_limit,
		   


		   );
if ($help)
{
        print "A suped up history command\n";
        print "Usage: $prog [options] \n";
        print "OPTIONS:\n";
        print " --cwd     : Only print the commands executed from the current working directory (default=no)\n";
        print " --long    : Print additional information about each command (default=no)\n";
        print " --date    : Only print commands within a certain number of days from today (default: no)\n";
        print " --help    : This message\n";

        exit (1);
}
if ($cwd){
	#just use the basename of the directory, othewise it is too complicated, but this will not return the right results if two directories in different locations 
	#have the same name
	$cwd=`pwd;`;chomp $cwd;
	$cwd=basename($cwd); 
}
my $HIST_FILE="~/.custom_history.txt";
#open HIST "<", "|tac $HIST_FILE";

open(HIST,"tac $HIST_FILE|");
my $x=1;
while (<HIST>){
	#each line contains the command and other info
	chomp $_;
	my @a=split /\t/,$_;
	my $output=$a[0]; #assume that the output desired is just the command
	my $flag=1; #assume that you print the command if it matches the supplied regex
	my $pattern_flag=1;
	$flag=&interpret_options($cwd,$long,$date_limit,$datenum,\@a);
	#$flag=&interpret_options($cwd,$long,\@a);
	if ($long){$output=$_;} #if long option,then the output is the entire line
	#$flag=1;
	if ( $pattern_flag==1 and $flag==1) {
		#print "    $x  $output\n";
		print "$x   $output\n";
	}
	$x++;

}
exit;
sub  interpret_options{
	my $cwd=shift;
	my $long=shift;
	my $date_limit=shift;
	my $datenum=shift;
	my $a_r=shift;my @a=@{$a_r};
	#$a[1]=~ s/:|-|\s|\+//g;
	my $final_flag=1;
	my @flag=1;
	if ($cwd){
		chomp $a[2] if ($a[2]);
		$a[2]=basename($a[2]) if ($a[2]);
		if ($cwd eq $a[2]){push (@flag,1);}
		else {push (@flag,0);}


	}

    if (defined $date_limit and ($date_limit>=0)){
    	my $difference=($a[4] - $datenum);
    	my $num=abs($difference);
    	if ($num<=$date_limit){
    		push (@flag,1);
    	}
    	else {push (@flag,0);}
    }

	#else {push (@flag,0);}
	@flag=sort { $a <=> $b } @flag;
	if ($flag[0]==0){
		$final_flag=0;
	}
	else {$final_flag=1;}
	return ($final_flag);

}

