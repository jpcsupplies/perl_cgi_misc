#!/usr/bin/perl -w
use strict; 
#use LWP::Simple;
use CGI qw/:standard *table start_ul/;

#Version 3.02 created by Nathan Anderson (c) 2004 CyberNexus General Industries
#Only bug seems to be messing up last link if it is last member of array in 
#menu file oddly.
#looks like i planned to have it write the title too..  add to todo list

#this data from a file
my @filelayout = (['']);
my $page=''; my $count=0; my $count2=0;
my $bgcolor=""; my $link=""; my $vlink="" ; my $alink =""; my $highlight="";
my $title=""; my $linktext=''; my $link=''; my $window=''; my $ntext="";
my $border=''; my $writefile=""; my $nextlink=""; 
my $currentdir='../'; my @input=''; my $i=0; my $flag=0; 

#we read the theme data and content in here
open(layout, "layout.dat") or die "Cant access file.";
	$filelayout[0]=[split(/\|/ , <layout>)];

	#we assign theme colors here
	$bgcolor=$filelayout[0][2]; $highlight=$filelayout[0][3];
        $border=$filelayout[0][4]; 
	$link=$filelayout[0][5]; $vlink=$filelayout[0][6]; $alink=$filelayout[0][7];
        $ntext=$filelayout[0][8];
	chomp($ntext);

	#we store the link list here
	for ($count = 1; $count <= ($filelayout[0][0]+1); $count++) {
        $filelayout[$count]=[split(/\|/ , <layout>)]; }
close layout;  

print header();
print start_html(-title=>'Website Generator');

print '<pre>Menu Layout loaded, ' . $#filelayout . " lines loaded\n";

print "----------------------\nLine " . (0) . 
" Theme Color Data and items count loaded\n";
print 'Menu Layout loaded, ' . $filelayout[0][0] . " menuitems listed\n";

print "----------------------\nLine " . (1) . " Picture in Menu loaded";

#main layout is built here using above data

for ($page = 2; $page <= $filelayout[0][0]; $page++) {

	#If we are not creating the first page which needs to be called default.htm
	#Then make the output file name a number based on the menu line
	if (($page) != 2) { $writefile=$currentdir . ($page) . '.htm'; }
	else { $writefile=$currentdir . 'default.htm'; }

	print "\n----------------------\nLine " . ($page) . 
        " File: $writefile being generated from '";

	open (layout, ">$writefile") or die "Cant access file.";
	

	      #page header
	      print layout start_html(-title=>'Computer Sections',
	      -author=>'sales@cybernexus.biz',
	      -meta=>{'keywords'=>
              'Trafalgar Australia Gippsland computer upgrade buy hardware component peripheral CPU motherboard mainboard wireless vga game nvidia 3d'},
	      -BGCOLOR=>$bgcolor, -link=>$link, -vlink=>$vlink, -alink=>$alink, 
              -text=>$ntext);  

		#Main Table
		print layout start_table({-border=>'1', -width=>'100%',
                -bordercolor=>'#111111', 
		-style=>'border-collapse: collapse; font-family: Verdana;'});
		print layout '<tr><td>';

		#Content Table
		print layout start_table({-border=>'1', -width=>'100%',
                -bordercolor=>'#111111', 
		-style=>'border-collapse: collapse; font-family: Verdana;'});
		print layout '<tr><td valign="top">';

		#navigation menu logo
		print layout '<center><img src="' . $filelayout[1][2] . '" alt="' . 
                $filelayout[1][1] . '"></center>';

		#navigation menu table
		print layout start_table({-border=>'1', -width=>'160', 
                -bordercolor=>'#111111', 
		-style=>'border-collapse: collapse; font-family: Verdana;'});

		#time to build the menu
		for ($count = 2; $count <= $filelayout[0][0]; $count++) { 
			if ($filelayout[$count][0] !=1) { 
                          $nextlink=$filelayout[($count +1)][0] . '.htm'; }
			else { $nextlink='default.htm'; }

			print layout '<tr>';
			#is it the current page? if not, draw link or heading
			if ($count != $page) {
				print layout '<td valign="top">';
				#if there is a link specified
				if ($filelayout[$count][2]) {
				  print layout '<a style="text-decoration: none;" href="';
				  #if a destination window is set, use real link and
                                  #destination
				  if ($filelayout[$count][3] =~ 'new') { 
					 print layout "$filelayout[$count][2]\" " .
					 "target=\"$filelayout[$count][3]\""; 
				  } 
				  #otherwise, use the generated filename
				  else { print layout $nextlink . '" '; }
				  print layout '>' . $filelayout[$count][1] . '</a>'; 
				}
			        #otherwise it must be a section heading
			        else { print layout '<b>'. $filelayout[$count][1] .
                                '</b>'; }
			} 
			else { # must be current page highlight it
			      print layout '<td bgcolor="' . $highlight .
                              '" style="vertical-align: top;">'; 
	            	      print layout '<i>'. $filelayout[$count][1] . '</i>';  
			}
			print layout '</td></tr>';
		}
		print layout end_table();
		print layout '</td>';

		#content for current section
		print layout '<td width="100%" bgcolor="#FFFFFF">';
	
		$count2=($page); #count variable
                $nextlink=$filelayout[$count2][2]; #stick the actual filename in
		chomp($nextlink); # get rid of newline at end if present		
		print "$nextlink'\n";
		chomp $filelayout[$count2][1];
		print "Section '$filelayout[$count2][1]',";
		if (!$filelayout[$count2][3]) { $flag++; print " Opens On Site. "; }

		#does the filename read in exist?
		#if so load it up, and insert in current page being generated.
		#otherwise ignore it and move on
		if ($flag) {
			if (-e $nextlink) {
				print "Local File. ";
				open (source, "$nextlink") or die "Cant access file.";
				  @input=<source>;
				close source;
				$flag++;
			
			} else { 
			
				if ($nextlink =~ 'http') {
					print " Internet File. ";
					#@input = get $nextlink;
					$flag++;
					$flag++;
				} else {
                                    print "\nNot webpage and-or no page to encode. "; 
                                }

			}
		} else { print " Opens in new browser window. \nExternal Website."; }
		if ($flag=="2") {
			print "Processing..\n";
			#is it a page we need to interpret or raw html
			if ($input[0] =~ '---') { 
				print "This is a webeditor page."; 
                                #image
				print layout '<center><img src="' . $input[1] . '">';                                           
				print layout '<h2>' . $input[3] . '</h2>'; #heading
				print layout '<font size="+1"><b>' . $input[4] . 
                                '</b></font></center><br>'; #summary
				$i=5; 
                                #rest of file
                                while ($i <= $#input) { 
                                  print layout $input[$i++] . '<br>'; 
                                } 
                        } else {
				print "This is a pure html page.";
				print layout '<!raw begin html input>';
			        $i=0; 
                                while ($i <= $#input) { print layout $input[$i++]; }
				print layout '<!raw end html imput>';
			}		
		} else { 
			if ($flag=="3") { 
			   print "Assuming HTML for website";
			   $i=0; 
                           while ($i <= $#input) { print layout $input[$i++]; } 
			}
		}
		$flag=0;

		print layout '</td></tr></table>';
		#print layout end_table();#for some bizzare reason this locks the script?
		print layout '</tr></td></table></body></html>';
		#print layout end_table();#for some bizzare reason this locks the script?
		#print layout end_html;#for some bizzare reason this locks the script?
	close layout;  
}
print end_html();

