#!/usr/bin/perl -w
use strict; #Disabled for now due to declaration issues
use CGI qw(:standard);

#############
# Variables #
#############
my ($page)=param('page');
my ($section)=param('section');
my $pages='pages.txt';
my $contents='';
my $datafile='file';
my $text='';
#my $admin='admin@' . virtual_host();
my $flag=undef;
#my $flagB='No';
my @content='';
my $startread="stop";
my $nopage="true";
my $table1='';
my $tablefile='';

##################
# Error Messages #
##################
my $nopagerror="Oops! It seems you forgot to specify a page in your request!";

my $nopagexist="The Requested Page \'$page\' Not Found In Our Records";
my $nosectionexist="The Requested Section \'$section\' Not Found In This Page Category";

##############################
# begin layout, title, colors#
##############################
print header(); # start_html(); ??
print '<HTML><HEAD><TITLE>CyberNexus General Industries</title>' .
      '</head>' .
      "\n" .
      '<body text="#FFFFFF" bgcolor="#000000" link="#FFFFFF" vlink="#FFFFFF"' .
      'alink="#FFFFFF"><font face="Arial,Helvetica">' .
      '<center><table COLS=1 WIDTH="612"><tr><td BGCOLOR="#000099"><font face="Arial,Helvetica">';

################
# page content #
################

########################
# was a page specified?#
######################## 
if ($page) { 
    ###################
    #yes! Show Heading#
    ###################
    print '<center>' , h1("$page") , '</center></td></tr>';
    print '<tr><td BGCOLOR="#3366FF">';
} else { 
    ################
    #no! Show Error#
    ################
    print '<center><h3>' . $nopagerror . '</td></tr><tr><td BGCOLOR="#3366FF">';
}

###########################
# was a section specified?#
###########################
if ((!$section) and ($page)) { $section='Index'; }
if ($section) { 
    ############################
    # yes! Show Section Heading#
    ############################
    print '<font face="Arial,Helvetica">';
    print h3("$section");
     
    # Create heading code to search data file for #
    $text = '~' . $page; chomp($text); 

    # Open pages data file #
    open(CONTENTS, $pages) or die "File Error.";
      #while still data in file, output next line to $_#
      while (<CONTENTS>) { 
        #while there is still data, check if it is our section#
        #store the next line if so.                           #
        $contents=$_;
        chomp($contents);
        if ($flag==1) { $datafile="$contents"; chomp($datafile); $flag++; }
        if ("$text" eq "$contents") { $flag++; }
      }
    close(CONTENTS);

    # Flag should equal 2, unless there is a dupliciate section   #
    # either way it will no longer be undefined/false             #

    ###############################
    # Thus:  was it a valid page? #
    ###############################  
    if ($flag) { 
       # Yes page is valid, lets try to open it #
       open(CONTENT, $datafile) or die "File Error";

       # If a section was specified use it. Otherwise use index #
       if ($section) { $text= '~' . $section; chomp($text); } else { $text = '~index'; }

       # Read file into memory #
       @content=<CONTENT>;  

       # By Default we assume we cant find the page specified.
       $nopage="true";
    
       foreach $contents (@content) {
          chomp($contents);

          # If a section appears, and its not the one we requested, stop the content feed
          if ($contents =~ /~/ && $contents ne $text) { $startread="stop"; }

          # if we have been given the go ahead, start printing the content
          if ($startread eq "go") {
             # check if we want a table inserted
             if ($contents =~ /^!/) {
	        $contents =~ tr/\!/ /;
                $tablefile = $contents;
                $table1=1; 
                &table;
             } 
             if ($table1==0) { print "$contents<br>\n"; } else { $table1=0; } 
          }

          # If we find the section we want, 'flick' the startread switch
          if ($contents eq $text) { $nopage="false"; $startread="go";  }
       }

      if ($nopage eq "true") { print "$nosectionexist"; }
    } else { print "$nopagexist"; }
}



#print '<!Please report any errors to ' . $admin . ">\n";
print '
<hr><b>';

#Click <i><a href="/scripts/engine.pl?page=info&section=Contact%20details">here</a></i> to
#contact us.</i><br>

print '
<strong><a href="/" target="_top">Return to main page</a></strong><p></td></tr>
<tr><td><font size="-2" face="Arial,Helvetica">
<center>Design by Phoenixx, Programming by Narcan and Phoenixx,
<br>&copy CyberNexus General Industries. 
</center></td></tr>
</table></center>
';

# end of html

print end_html;



############
#useful notes
#print '<p>Server Name ' . server_name() . "<\/p>";
#print '<p>Virtual Host ' . virtual_host(). "<\/p>";
#print '<p>Referer \'' . referer(). "\'<\/p>";
############
#open(TDATA, $testdata) or die "File Error $!";
#while (<TDATA>) {
#	$tdata=$_;
#	print "$tdata<br>";
#	#insert if statements to interpret output/input here
#}
#close(TDATA);
############


# Table Procedure
sub table { 
#order link generator added by phoenixx
my $button='';
my $temp=0;
#my $a=0;


# Table generator written for phoniexx's web site, by narcan
# The format the file has to be in, is as follows:

# Catagory,Supplier,Product,Price
# MEMORY,Hyandai,128MB SDRAM PC133 168pin,$312.00,cart

#
# You tell the script to display a table by inserting 
# !tablefilename.whatever in the section file


my $cellwidth="0";
my $cellpadding="2";
my $cellspacing="0";
my $cellbgcolor1="#99CCFF";
my $cellbgcolor2="#D5EAFF";

my $tablewidth="90%";
my $tableborder="2";
my $tablebgcolor="#6699FF";

my $headerfontcolor="white";
my $headerfontface="Arial";
my $headerfontsize="2";

my $mainfontcolor="black";
my $mainfontface="Arial";
my $mainfontsize="2";

my $linenumber=0;
my $color=0;
my @TABLE='';
my @fields='';
my $line=0;
my $nofields='';
my $cellbgcolor='';


open(TABLE, $tablefile) or die "Error, cannot find table\n";
  @TABLE=<TABLE>;
close(TABLE);

# HTML HEADER
print "<HTML>\n";
print "<BODY>\n";

# Table Header
print "<div align=center>\n";
print "<table border=$tableborder cellpadding=$cellpadding" .
      " cellspacing=$cellspacing width=$tablewidth bgcolor=$tablebgcolor>\n";

foreach $line (@TABLE) {
  $linenumber++;
  @fields = split(/\,/, $line);
  # Display title
  if ($linenumber==1) {
	$line=$line . ',Order'; #added by phoenixx for ordering system
	@fields = split(/\,/, $line);

	$nofields = ($line =~ tr/\,/ /) + 1 ;
        #print "<tr>\n";
	  for ($a = 0; $a < $nofields; $a++) {
	    print "<td width=$cellwidth><font face=$headerfontface size=$headerfontsize" .
            " color=$headerfontcolor><strong>@fields[$a]</strong></font></td>";
	  }
	print "</tr>\n";
  }
  else
  {

#--Phoenixx Notes
        #(with a shopping cart here is where we generate the link)
        # edit the @fields array so we have an extra entry with the cart button
        # total records = price || total-1=item || total -2 = serial 
        $temp=@fields-4;
     $button='<form  action="http://www.cybernexus.biz/scripts/order.pl" method="post">' .
     '<input type="Hidden" name="step" value="1">   <input type="Hidden" name="item_no"' .
        'value="' . @fields[$temp] .'">';
        $temp=@fields-3;
     $button=$button . '<input  type="Hidden" name="item" value="' . @fields[$temp] .'">';
        $temp=@fields-2;
  $button=$button . '<input  type="Hidden" name="price" value="' . @fields[$temp] . '">';
     $button=$button . '<input  type="Submit" name="order" value="Buy Now"></form>';
     $temp=@fields+1;

##$line=$line . ',' . $button;  }



     @fields = split(/\,/, $line);
     print "<tr>\n";
     $linenumber++;


     if ($color==0){ $cellbgcolor=$cellbgcolor1; $color=1; } 
     else { $cellbgcolor=$cellbgcolor2; $color=0;  }    

     for ($a = 0; $a < $nofields; $a++) {
  	if (@fields[$a] =~ 'cart') { 
           print "<td width=$cellwidth bgcolor=$cellbgcolor><font face=$mainfontface" .
           "size=$mainfontsize color=$mainfontcolor>$button</font></td>\n"; 
        } else { 
           print "<td width=$cellwidth bgcolor=$cellbgcolor><font face=$mainfontface" .
           " size=$mainfontsize color=$mainfontcolor>@fields[$a]</font></td>\n"; 
        }
     }
     print '</tr>';
  }
}


#table footer

print "</table>\n";
print "</div><p>\n";

}
