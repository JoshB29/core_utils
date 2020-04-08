#!/usr/bin/perl
use warnings;
use strict;
my $file_1=shift;
my $file_2=shift;
my @file_1=`cat $file_1`;foreach (@file_1){chomp;}
my @file_2=`cat $file_2`;foreach (@file_2){chomp;}

foreach my $line_1 (@file_1){
	chomp $line_1;
	foreach my $line_2 (@file_2){
		chomp $line_2;
		print "$line_1\t$line_2\n";

	}
}