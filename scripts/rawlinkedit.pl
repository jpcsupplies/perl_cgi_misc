#!/usr/bin/perl -w
use strict;
use LWP::Simple;
use CGI qw(:standard);

#To be adapted to allow direct editing of the layout.dat file.

#This is a prototype web text editor
#not particularly secure, but should work.

#assign the variables for the data
my $mode=param('mode'); #read or write?
my $homepage=param('edit'); #file to open
my $html=param('html'); #submitted data
my $safepage='http://www.trafalgar.org.au/secure/'; #security - referring page
my $user=param('user'); #security - who changed this?
my $ownpage='http://www.trafalgar.org.au/scripts/textedit.pl'; #used to allow editing
my $ownscript='/scripts/textedit.pl';
my $actualpage=referer(); # parameter to check with against safepage

# print our header.
print header();
print '<html>';
if (!$mode) { $mode = "read" }
if (!$actualpage) { $actualpage='Typing URL in browser manually' }

print "You are from $actualpage, your mode is $mode";
print '<p>It is <b>STRONGLY</b> recommended you exercise care when making changes. Make sure you know what you are doing! <br>';
#security check
if (($safepage eq $actualpage) || ($ownpage eq $actualpage)) {
	if ($mode eq 'write') { &write($html,$homepage) } 
	else { &read($homepage)	 }
} else { &error(1) }
# end of script end the html
print end_html;


#############
#Sub Routines
#############

#######
#errors
#######
sub error { 
if($_[0] == 1) { print '<h2>Error! Unauthorised User</h2>'; } # no mode param
    elsif ($_[0] == 2) { print '<h2>Error! invalid page specfied</h2>'; } # no page param
    elsif ($_[0] == 3) { print '<h2>Error! incorrect user specified</h2>'; } # no/wrong user
    else{ print '<h2>Error! unknown error!!</h2>'; } # no error at all?
}


###################
#read text file
###################
sub read { 
my $page='';
my $tdata=" ";

$page="$_[0]";


print '
<form method="post" action="' . $ownscript . '">
<input type="Hidden" name="mode" value="write">
<input type="Hidden" name="homepage" value="' . "$_[0]" . '">
<input type="Hidden" name="edit" value="' . "$_[0]" . '">
<br><center>
<hr><p><textarea name="html" cols="80" rows="20" wrap="on">';

open(TDATA, $page) or die "File Error $!";
while (<TDATA>) {
	$tdata=$_;
	
	print "$tdata";
 }
close(TDATA);

print '</textarea>
<input type="submit" name="post" value="Save Changes">
<input type="reset" name="Reset" value="Revert">
</form></center>

<pre>
Instructions here.
</pre><br>

';
}

################
#write text file
################
sub write {
	my $file='./'; 
	my $tdata=" ";

print '<p>Writing..';
$file="$_[1]";

	#write to file

	# open file for output, >  or append >>
	open (TDATA, ">$file") or die "<h1>Error Processing file: $!";
		print TDATA "$_[0]";
	close(TDATA);

print get 'http://www.trafalgar.org.au/scripts/writesite.pl';

	print 'Page updated</p>';
}