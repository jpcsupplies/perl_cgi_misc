#!/usr/bin/perl -w
# counter3.pl reviews website ssi


#use strict;
use LWP::Simple;
use CGI qw(:standard);
#use CGI;


$q = new CGI;
$total="1";
$counterfile = "count3.tot";

                   open(COUNT,$counterfile); # Open the counter file
                   $total=<COUNT>; # Read in the first (and only) line
                   close(COUNT); # Close the file

                   $total++; # Increment the count by 1

                   open(COUNT,">$counterfile");# Open the file in 
                   # write mode
		   print COUNT $total; # Store the new count in 
                   # the file
                   close(COUNT); # Close the file and print the result

                   
	print 	$q->header;
#		$q->start_html('count'), 	
	print	("You are visitor number: $total\n");	
#	print	$q->end_html;           
