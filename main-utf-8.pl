#!/usr/perl

# this code is intended to be called from inside a makefile
# located in a content creation source directory


# load TCGS module (mandatory)

use TCGS;

print "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">\n";

# html type (mandatory) and language (optional)

print "<HTML>";
print "\n";

# start HEADER

print "<HEAD>\n";

# content description

$charsetfile = TCGS::findfile "charset.txt";
if (-f "$charsetfile") {
	print "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=";
	TCGS::from "$charsetfile"; 
	print "\">";
	print "\n";
}

$styletypefile = TCGS::findfile "styletype.txt";
if (-f "$styletypefile") {
	print "<meta http-equiv=\"Content-Style-Type\" content=\"";
	TCGS::from "$styletypefile";
	print "\">";
	print "\n";
}

$langfile = TCGS::findfile "lang.txt";
if (-f "$langfile") {
	print "<meta http-equiv=\"Content-Language\" content=\"";
	TCGS::from "$langfile";
	print "\">";
	print "\n";
}

# base url definition (optional)

$basefile = TCGS::findfile "base.txt";
if (-f "$basefile") {
	print "<BASE HREF=\"";
	TCGS::from "$basefile";
	print "\">\n";
}

# cache control

$cachefile = TCGS::findfile "cache.txt";
if (-f "$cachefile") {
	$cache = TCGS::cont "$cachefile";
	print "<meta http-equiv=\"cache-control\" content=\"$cache\">\n";
	print "<meta http-equiv=\"pragma\" content=\"$cache\">\n";
}

# automatic favicon reference (optional)

$faviconfile = TCGS::findfilerelativ "favicon.ico";
if (-f "$faviconfile") {
	print "<LINK REL=\"SHORTCUT ICON\" HREF=\"$faviconfile\">\n";
}

# automatic stylesheet definition

$tcgscssfile = TCGS::findfilerelativ "tcgs.css";
if (-f "$tcgscssfile") {
	print "<LINK REL=STYLESHEET TYPE=\"text/css\" HREF=\"$tcgscssfile\">\n";
}

# user stylesheet definition (currently just a single style allowed)

$stylesheetfile = TCGS::findfile "stylesheet.txt";
if (-f "$stylesheetfile") {
	$stylesheet = TCGS::cont "$stylesheetfile";
	$stylesheetfile = TCGS::findfilerelativ "$stylesheet";
	if (-f "$stylesheetfile") {
		print "<LINK REL=STYLESHEET TYPE=\"text/css\" HREF=\"$stylesheetfile\">\n";
	}
}

# automatic javascript reference

$tcgsjsfile = TCGS::findfilerelativ "tcgs.js";
if (-f "$tcgsjsfile") {
	print "<SCRIPT TYPE=\"text/javascript\" SRC=\"$tcgsjsfile\">\n";
	print "</SCRIPT>\n";
}

# this, if we have corresponding files

@metatags = (robots,description,author,keywords);
foreach $meta (@metatags) {
	$metafilename = $meta . ".txt";
	$metafile = TCGS::findfile "$metafilename";
	if (-f $metafile) {
		print "<meta name=\"$meta\" content=\"";
		TCGS::from "$metafile";
		print "\">\n";
	}
}

# this automatically ... 

print "<meta name=\"generator\" content=\"TCGS\">\n";
print "<meta name=\"MSSmartTagsPreventParsing\" content=\"true\">\n";
print "<meta http-equiv=\"imagetoolbar\" content=\"no\">\n";

# and date

($sec,$min,$hour,$dom,$mon,$year,$wday,$yday,$isdst) = localtime(time());
print "<meta name=\"date\" content=\"";
printf ("%4.4d-%2.2d-%2.2d",$year+1900,$mon+1,$dom);
print "\">\n";

# title is taken from file or from internal function

if (-f "title.txt") {
	print "<TITLE>"; TCGS::from "title.txt"; print "</TITLE>\n";
} else {
	print "<TITLE>"; TCGS::title; print "</TITLE>\n";
}

print "</HEAD>";
print "\n";

# end of HEAD and start of BODY

print "<BODY>";
print "\n";


#$xxxxxxxxxxxxxx = TCGS::findfile "xxxxxxxxxxxxx";
#if (-f "$xxxxxxxxxxxxxx") {
#	TCGS::from ("$xxxxxxxxxx","HTML");
#}


# top of the page is made from the logo bitmap and the top navigation area

print "<TABLE>";
print "<TR>";

print "<!-- top logo -->";
print "<TD VALIGN=TOP>";
#if (-f "logo.html.txt") {
#	TCGS::from ("logo.html.txt","HTML");
#}
$logo = TCGS::findfile "logo.html.txt";
if (-f "$logo") {
	TCGS::from ("$logo","HTML");
}
print "</TD>";
print "\n";

print "<!-- top navigation -->";
print "<TD VALIGN=TOP WIDTH=\"100%\">";
#if (-f "topnav.html.txt") {
#	TCGS::from ("topnav.html.txt","HTML");
#}
$topnav = TCGS::findfile "topnav.html.txt";
if (-f "$topnav") {
	TCGS::from ("$topnav","HTML");
}
print "</TD>";
print "\n";

print "</TR>";
print "</TABLE>";
print "\n";

# next is a "you-are-here-area"

print "<P>";
print "<!-- you are here -->";
print "<font size=-1>";
TCGS::youarehere;
print "</font>";
print "</P>";
print "\n";

# below that we follow the widely accepted three columns table design...

print "<TABLE>\n";
print "<TR>";

# and start with the left navigation area

print "<!-- left navigation -->";
print "\n";
print "<TD VALIGN=TOP WIDTH=\"20%\">";
#if (-f "leftnav.html.txt") {
#	TCGS::from ("leftnav.html.txt","HTML");
#}
$leftnav = TCGS::findfile "leftnav.html.txt";
if (-f "$leftnav") {
	TCGS::from ("$leftnav","HTML");
}
print "</TD>";
print "\n";

# create the main content area in the middle

print "<!-- main content -->";
print "\n";
print "<TD VALIGN=TOP WIDTH=\"40%\">";

# start with content count 000, increase as long we have
# files matching the glob operator

$i = 0;
$nnn = sprintf("%03d",$i);
$content_count = 0;

# for file in file list, determine content and file type


while ($i <= 999) {
if (@file_list = glob("$nnn.\*.\*")) {

	$content_count++;
	
	# set a default image alignment
	$imgalign = "right";
	# reset all other image vars
	$imgalt = "";
	$imgsrc = "";
	$imghref = "";
	
	print "<P>";
	
	# extract content type for each file in list
	foreach $file ( @file_list ) {
	
		# get the two string before and after the last dot
		$file =~ /.*\.(.*)\.(.*)/;
		$content_type = $1;
		$data_type = $2;
		#print "<!-- contenttype:$content_type -->\n";
		#print "<!-- datatype:$data_type -->\n";
		if ($content_type =~ /^html$/) {
			TCGS::from ("$file", "HTML");
		} elsif ($content_type =~ /^text$/ || $content_type =~ /^span$/) {
			TCGS::from "$file";
		} elsif ($content_type =~ /^head$/) {
			print "<H1>";
			TCGS::from "$file";
			print "</H1>";
		} elsif ($content_type =~ /^subhead$/) {
			print "<H3>";
			TCGS::from "$file";
			print "</H3>";
		} elsif ($content_type =~ /^big$/) {
			print "<BIG>";
			TCGS::from "$file";
			print "</BIG>";
		} elsif ($content_type =~ /^cite$/) {
			print "<CITE>";
			TCGS::from "$file";
			print "</CITE>";
		} elsif ($content_type =~ /^strong$/) {
			print "<STRONG>";
			TCGS::from "$file";
			print "</STRONG>";
		} elsif ($content_type =~ /^italic$/) {
			print "<I>";
			TCGS::from "$file";
			print "</I>";
		} elsif ($content_type =~ /^bold$/) {
			print "<B>";
			TCGS::from "$file";
			print "</B>";
		} elsif ($content_type =~ /^em$/) {
			print "<EM>";
			TCGS::from "$file";
			print "</EM>";
		} elsif ($content_type =~ /^type$/) {
			print "<TT>";
			TCGS::from "$file";
			print "</TT>";
		} elsif ($content_type =~ /^mailto$/) {
			$mailto = TCGS::cont "$file";
			print "<A HREF=\"mailto:$mailto\">";
			print "$mailto";
			print "</A>";
		} elsif ($content_type =~ /^pre$/) {
			TCGS::from ("$file", "PRE");
		} elsif ($content_type =~ /^imgalign$/) {
			# store the content of file for use with
			# imgsrc content type
			$imgalign = TCGS::cont "$file";
		} elsif ($content_type =~ /^imgalt$/) {
			# store the content of file for use with
			# imgsrc content type
			$imgalt = TCGS::cont "$file";
		} elsif ($content_type =~ /^imghref$/) {
			# store the content of file
			$imghref = TCGS::cont "$file";
		} elsif ($content_type =~ /^imgsrc$/) {
			$imgsrc = TCGS::cont "$file";
			# build the image table from elements
			($tablewidth, $tableheight) = TCGS::getimagesize ($imgsrc);
			print "<TABLE class=\"image-$imgalign\" width=\"$tablewidth\" cellpadding=\"0\" cellspacing=\"0\" align=\"$imgalign\">";
			print "<TR>";
			print "<TD>";
			# if we have a href we build a link from it
			if ($imghref =~ /.+/) {
				if (-f $imghref) {
					($width, $height) = TCGS::getimagesize ($imghref);
				} else {
					$width = 800;
					$height = 600;
				}
				$width += 40;
				$height += 40;
				$windowopensize = "width=$width,height=$height";
				$windowopenlook = "locationbar=no,menubar=no,resizable=yes,status=no,scrollbars=1";
				print "<A HREF=\"$imghref\" onclick=\"window.open('$imghref','Picture','$windowopensize,$windowopenlook'); return false;\">";
			}
			print "<IMG SRC=\"$imgsrc\" ALT=\"$imgalt\">";
			if ($imghref =~ /.+/) {
				print "</A>";
			}
			print "</TD>";
			print "</TR>";
			print "<TR class=\"image-text\">";
			print "<TD>";
			print "$imgalt";
			print "</TD>";
			print "</TR>";
			print "</TABLE>";
			# deleted the next BR tag to align the table top with the text top
			##print "<BR>";
		} elsif ($content_type =~ /^table$/) {
			TCGS::table_simple "$file";
			
		} elsif ($content_type =~ /^ranking$/) {
		
			if ($data_type =~ /^csv$/) {
				TCGS::table ($file,"RANKING",',','\"');
			} else {
				TCGS::table ($file,"RANKING",':','');
			}

		} elsif ( ($content_type =~ /^list$/) or ($content_type =~ /^ulist$/) ) {
			TCGS::list ($file,"UL",',','\"');
		} elsif ($content_type =~ /^olist$/) {
			TCGS::list ($file,"OL",',','\"');
		} elsif ($content_type =~ /^exec$/) {
			do "$file";
		} else {
			print "<!-- found unknown content -->\n";
		} # end content_type
	} # end foreach
	
	print "</P>";
	print "\n";
} # end ´file_list
$i++;
$nnn = sprintf("%03d",$i);
} # end while

# if we have no content at the time now we run autoindex as a default

if ($content_count == 0) {
	TCGS::autoindex;
}

print "<HR>\n";

print "</TD>";

# and finally the right navigation mainly used for advertisements

print "<!-- right navigation -->";
print "<TD VALIGN=TOP WIDTH=\"20%\">";
#if (-f "rightnav.html.txt") {
#	TCGS::from ("rightnav.html.txt","HTML");
#}
$rightnav = TCGS::findfile "rightnav.html.txt";
if (-f "$rightnav") {
	TCGS::from ("$rightnav","HTML");
}
print "</TD>";

print "</TR>";

# end of the three pane table

print "</TABLE>\n";

# do not forget the closing p tag (see above)

#print "</P>";

# foot navigation

print "<P>";
#if (-f "footnav.html.txt") {
#	TCGS::from ("footnav.html.txt","HTML");
#}
$footnav = TCGS::findfile "footnav.html.txt";
if (-f "$footnav") {
	TCGS::from ("$footnav","HTML");
}
print "</P>";
print "\n";

print "<DIV ALIGN=\"center\">";
print "made with: ";
print "<A NAME=\"TCGS\"></A>";
#print "<INPUT TYPE=\"button\" VALUE=\"TCGS\" onClick=\"TcgsAbout()\">";
#print "<SPAN onClick=\"TcgsAbout()\">TCGS</SPAN>";
print "<A HREF=\"#TCGS\" onClick=\"TcgsAbout()\">TCGS</A>";
#print "<A onClick=\"TcgsAbout()\">TCGS</A>";
print "\n";
printf ("(%4.4d-%2.2d-%2.2d)",$year+1900,$mon+1,$dom);
print "</DIV>";

print "</BODY>\n";
print "</HTML>\n";
