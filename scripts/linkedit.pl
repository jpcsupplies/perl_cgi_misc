#!/usr/bin/perl -w
use strict;
#use LWP::Simple;
use CGI qw(:standard);

#This is a prototype link editor
#not particularly secure, but should work.
#i may have this only render the data, and use another script to write to the link layout

#assign the variables for the data
#my $safepage='http://www.trafalgar.org.au/secure/'; #security - referring page
#my $actualpage=referer(); # parameter to check with against safepage
#my $currentdir='../www/';  

my @filelayout = ( [ ] ); my $pels=1; 
my $bgcolor=""; my $highlight=""; my $border=''; my $link="";
my $link=''; my $vlink="" ; my $alink =""; my $ntext="";
my $count=0; my $graphiccaption=""; my $graphicfilename="";

# print our header.
print header();
print start_html(-title=>'Website Menu Link Editor');

#stick an if here to check for input data

#we read the theme data and content in here
open(layout, "layout.dat") or die "Cant access file.";
	$filelayout[0]=[split(/\|/ , <layout>)];

	#we assign theme colors here
	$pels=$filelayout[0][1]; $bgcolor=$filelayout[0][2]; $highlight=$filelayout[0][3]; 
	$border=$filelayout[0][4]; $link=$filelayout[0][5]; $vlink=$filelayout[0][6]; 
	$alink=$filelayout[0][7]; $ntext=$filelayout[0][8];
	chomp($ntext);

	#we store the link list here
	for ($count = 1; $count <= ($filelayout[0][0]+1); $count++) { $filelayout[$count]=[split(/\|/ , <layout>)]; }

	#we store the menu graphic here
	$graphiccaption=$filelayout[1][1]; $graphicfilename=$filelayout[1][2]; chomp($graphiccaption);
close layout;  

print '<h1>Website Menu Editor</h1><p><h2>Edit Existing Data</h2>';
print '<form action="/scripts/linkedit.pl" method="post"><b>Menu Formatting</b><br>';
print 'Width of menu (every 8 = 1 letter roughly)<input type="Text" name="pels" value="' .
	$pels . '"><p>';
print '<b>Colors</b>:<br>Background <input type="Text" name="bgcolor" value="' . $bgcolor 
	.'" size="8" maxlength="8"> Highlight <input type="Text" name="highlight" value="' .
	$highlight . '" size="8" maxlength="8"> Border<input type="Text" name="border" value="' .
	$border . '" size="8" maxlength="8"><p>';
print '<b>Text</b><br> Links<input type="Text" name="link" value="' .
	$link .'" size="8" maxlength="8"> Visited Links<input type="Text" name="vlink" value="'.
	$vlink .'" size="8" maxlength="8"> Active Link <input type="Text" name="alink" value="'.
	$alink .'" size="8" maxlength="8"><br>Normal Text <input type="Text" name="ntext" value="'.
	$ntext .'" size="8" maxlength="8"><p>';
print '<b>Menu Graphic</b><br>Caption<input type="Text" name="graphiccaption" value="'.
	$graphiccaption . '" size="30"> Location<input type="Text" name="graphicfilename" value="'.
	$graphicfilename .'" size="40"><p>';

#insert a for loop and spit out each link here based on scripts\example\form.html

print '<b>Menu Items</b><br>Note: Leave File/Website Blank for a Category or Space.';
for ($count = 2; $count <= ($filelayout[0][0]); $count++) { 
	#print $count .',';

	chomp($filelayout[$count][2]);
	chomp($filelayout[$count][1]);

	print '<br>Link Caption<input type="Text" name="caption'.
		$count .'" value="' . $filelayout[$count][1] . 
		'"> File / Website<input type="Text" name="link' . $count . '" value="' .
		$filelayout[$count][2] .'">';
	print ' Load as:<select name="type' . $count . '">';

	#here we need to set selected based on target info


	if (!$filelayout[$count][2]) {
	#It Must be a space or heading	

		if ("$filelayout[$count][1]" eq '&nbsp;') { 
			#its a space
			print '<option selected>Space</option><option>Category</option>';
		} else { 
			#its a category heading
			print '<option selected>Category</option><option>Space</option>';
		}
		print '<option>Inside Website</option><option>New Window</option>';
	} else { 
		#It must be a menu item
		if (!$filelayout[$count][3]) {
			print '<option selected>Inside Website</option><option>'.
			'New Window</option><option>Space</option><option>Category</option>';
		} else { print '<option selected>New Window</option><option>'.
			 'Inside Website</option><option>Space</option><option>Category</option>'; }
	}
	print '</select>' . "\n";
	
	#here we need to enable/disable buttons based on target file mode
	#which will require loading the first line of each page and checking
	#if it starts with --- or if it is http
	#'<form  action="/scripts/textedit.pl" method="post">' .
	#'<input  type="Hidden" name="item" value="' . $count .'">';
	#	'<input  type="Submit" name="webeditor" value="Web Edit">' .
	#	'<input disabled type="Submit" name="htmledit" value="Edit HTML">
	#</form>
}

print '<br><b>Save Any Changes</b><br><input type="Submit" name="edit" value="Save">------<input  type="Reset"></form><p><form action="/scripts/rawlinkedit.pl" method="post"><b>Advanced Users:</b><br><input type="Submit" name="Direct" value="Directly Edit Data File"></form>';


# this may use an external script to make coding easier
print '<hr><p><h2>Add New Link:</h2><form action="/scripts/linkedit.pl" method="post">'.
'Link Caption<input type="text" name="caption"> File or Website Link<input  type="Text" name="link">
 Treat as:<select name="type">
<option selected>Inside Website</option><option>New Window</option>
<option>Space</option><option>Category</option></select>

<p>Create what file type?<br><select name="format">
<option>Dont create anything</option><option>Raw HTML</option>
<option>Text WebEditor</option></select>
<p><input  type="Submit" name="add" value="Add"></form>';

print end_html();


#######
#NOTES#
#######
#check for data input.. if not
	#open layout.dat
	#format data in a form on screen
	#disable buttons as appropriate, eg, websites disable all
	#webedit disables html, html disables webedit etc
#otherwise.. check data, write to disk if ok.
#redraw new data


