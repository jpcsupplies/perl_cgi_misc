#!/usr/bin/perl -w 

use strict; 
use CGI qw(:standard);

my $pages='pages/pc.txt';
my $contents='';

print header() . start_html();

#open(TDATA, $testdata) or die "File Error $!";
#while (<TDATA>) {
#	$tdata=$_;
#	print "$tdata<br>";
#	#insert if statements to interpret output/input here
#}
#close(TDATA);

print "opening file<p>";

open(CONTENTS, $pages) or die "File Error";
	while (<CONTENTS>) { 
        	$contents=$_;
		print "$contents<br>";
	}
close(CONTENTS);

print end_html;

