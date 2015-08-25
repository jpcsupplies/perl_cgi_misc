#!/usr/bin/perl -w 
#!/usr/local/bin/perl

use File::Find;

print "Content-type: text/html\n\n";
print "<html>\n" ;
print "\n" ;
print "<head>\n" ;
print "<title>$ENV{'SERVER_NAME'} CGI Script Help File</title>\n" ;
print "</head>\n" ;
print "\n" ;
print "<body bgcolor=\"#FFFFFF\" text=\"#000000\">\n" ;
print "\n" ;
print "<p align=\"center\"><font face=\"Verdana\"><br>\n" ;
print "Dot Matrix CGI Script Help File<BR>\n" ;
print "Please see the bottom of this page if you need assistance installing a script.</p>\n" ;
print "<div align=\"center\"><center>\n" ;
print "\n" ;
print "<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"75%\" bordercolor=\"#000000\">\n" ;
print "<tr>\n" ;
print "<td bgcolor=#000000><BR><CENTER><B><font color=#FFFFFF size=4>Basic Configuration Information</B></font></CENTER><p></td></tr>\n" ;

print "<tr>\n" ;
print "<td><font color=\"#000000\" face=\"Verdana\">Your path to Perl is correct.<br>\n" ;
print "Your server is running Perl version<p>\n" ;
print "<strong> $] </strong></font><p></td>\n" ;
print "</tr>\n" ;
print "<tr>\n" ;
print "<td>Your domain name is<p>\n" ;
print "<strong> $ENV{'SERVER_NAME'} </strong></p>\n" ;
print "<p></td>\n" ;
print "</tr>\n" ;
print "<tr>\n" ;
print "<td>The complete system path to this script is:<p>\n" ;
print "<strong>$ENV{'SCRIPT_FILENAME'} </strong></p>\n" ;
print "<p></td>\n" ;
print "</tr>\n" ;
print "<tr>\n" ;
print "<td>The URL of this script is:<p>\n" ;
print "<strong>http://$ENV{'SERVER_NAME'}$ENV{'SCRIPT_NAME'}</strong><p></td>\n" ;
print "</tr>\n" ;
print "<td>The RELATIVE URL of this script is:<p>\n" ;
print "<strong>$ENV{'SCRIPT_NAME'}</strong><p></td>\n" ;
print "</tr>\n" ;
print "<tr>\n" ;
print "<td>Your server consists of:<p>\n" ;
print "<strong>$ENV{'SERVER_SOFTWARE'}</strong><p></td>\n" ;
print "</tr>\n" ;
print "<tr>\n" ;
print "<td bgcolor=#000000><BR><CENTER><B><font color=#FFFFFF size=4>Detailed Information:</B></font></CENTER><p></td></tr><HR>\n" ;

    while(($ekey, $eval) = each(%ENV)){
	print "<tr><td><B>$ekey </B>: $eval<br></td></tr>\n";
	if ($ekey eq 'PATH') {
	    $path = $eval;
	}
    }
print <<raw;
<hr><TR><TD>
<h3>Other Server Info<BR><HR></h3>
<tt>
raw
    $uname = `uname -a`;
print "<b>Uname info:</b> $uname<hr><br>\n";
$mydir = `ls -ld .`;
print "<b>Working directory:</b> $mydir<hr><br>\n";
$mypath = `pwd`;
print "<b>Path to current directory:</b> $mypath<hr><br>\n";
$myid = `id`;
print "<b>Ids:</b> $myid<hr><br>\n";
$tarfound = $perlfound = $smfound = 0;
@paths = split(/:/, $path);
foreach (@paths) {
    if ( -e "$_/tar" ) {
	$tarfound = 1;
	print "<b>Tar found:</b> $_/tar<hr><br>\n";
    }
    if ( -e "$_/perl" ) {
	$perlfound = 1;
	print "<b>Perl found:</b> $_/perl<hr><br>\n";
        $perlversion = `$_/perl -v`;
        print "<b>Perl version:</b> $perlversion<hr><br>\n";
    }
    if ( -e "$_/sendmail" ) {
	$smfound = 1;
	print "<b>Sendmail found:</b> $_/sendmail<hr><br>\n";
    }
}
if ($tarfound == 0) {
    print "<B>MAY be a problem: tar not found on server PATH</b><hr><br>\n";
}
if ($perlfound == 0) {
    print "<B>MAY be a problem: perl not found on server PATH</b><hr><br>\n";
}
if ($smfound == 0) {
    print "<B>MAY be a problem:<BR>Sendmail not explicitly found on server PATH</B><br>\n";
$wheremail =`whereis sendmail`;
@sendmails = split(" ",$wheremail);
print "<B>Please try one of the following:</B><br>\n";
foreach $ml(@sendmails){
print "$ml<BR>\n";
}
print "<hr>\n";

}
print "</tt>\n";


print "<tr>\n" ;
print "<td bgcolor=\"#000000\"><font color=\"#FFFFFF\" face=\"Verdana\" size=\"4\"><BR><B><CENTER>The following modules are installed:</B></CENTER><br>\n" ;

find(\&hunter,@INC);
$modcount = 0;
foreach $line(@discmods){
 		$match = lc($line);
 		if ($found{$line}[0] >0)	{
 		$found{$line} = [$found{$line}[0]+1,$match]
 		}	
 		else {
 		$found{$line} = ["1",$match];$modcount++}}
 		@discmods = sort count keys(%found);
 		sub count {return $found{$a}[1] cmp $found{$b}[1]}
 		$third = $modcount/3;$count=0;
 		foreach $mod(@discmods){
 		chomp $mod;	$count++;
 		if ($count <= $third){
 		print qq~<TR><TD>${font}$mod</TD></TR>~;
 			}	
 		else {push (@mod1,$mod)}}
 		$count = 0;foreach $mod1(@mod1){
 		chomp $mod1;
 		$count++;
 		if ($count <= $third){
 		print qq~<TR><TD>${font}$mod1</TD></TR>~;	}
 		else {push (@mod2,$mod1)}}
 		$count = 0;
 		foreach $mod2(@mod2){
 		chomp $mod2;
 		$count++;
 		if ($count <= $third){
 		print qq~<TR><TD>${font}$mod2</TD></TR>~;	}}

print "</tr>\n" ;
print "<tr>\n" ;
print "<td><p align=\"center\">Script by \n" ;
print "<a href=\"http://www.dotmatrix.net\">Dot Matrix</a>.</font></td>\n" ;
print "</tr>\n" ;
print "</table>\n" ;
print "</center></div>\n" ;
print "<p align=\"center\"><font face=\"Verdana\">Dot Matrix provides fast, professional CGI script\n";
print "installations as well as custom applications &amp; modifications to existing\n";
print "scripts.</font></p>\n";
print "<p align=\"center\"><a href=\"http://www.dotmatrix.net\"><font face=\"Verdana\">Dot Matrix Home Page</font></a></p>\n";
print "<p align=\"center\"><a href=\"http://dotmatrix.net/scripts/install/\"><font face=\"Verdana\">Installation\n";
print "Services</font></a></p><CENTER>\n";
print "<p align=\"center\"><font face=\"Verdana\">Speak to us now!</font>\n";
print <<EOF;
<script language="JavaScript" src="http://www.dotmatrix.net/phplive/js/status_image.php?base_url=http://www.dotmatrix.net/phplive&l=Tony&x=1&deptid=1&btn=1"></script>
EOF
print "</CENTER>\n";
print "</body>\n" ;
print "</html>\n" ;

sub hunter {
$count = 0;
if ($File::Find::name =~ /\.pm$/){
open(MODFILE,$File::Find::name) || return;
	while(<MODFILE>){
				if (/^ *package +(\S+);/){
								push (@discmods, $1);
												last;
															}
														}
													}
												}
												
