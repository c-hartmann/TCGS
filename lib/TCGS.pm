package TCGS;

# Tiny Content Generation System

# standard CPAN modules
use Cwd;
use File::Basename;

# extra modules
# ImageMagick (ftp://ftp.imagemagick.org/pub/ImageMagick/binaries)
#use Image::Magick;
# GraphicsMagick (ftp://ftp.graphicsmagick.org/pub/GraphicsMagick/windows/)
use Graphics::Magick;

# my procedures ...

# get the geometry (i.e. size) of an image file
sub getimagesize {
	my ($file) = @_;
	#my $image=Image::Magick->new;
	my $image=Graphics::Magick->new;
	my ($x, $width, $height);
	$x = $image->Read("$file");
	($width, $height) = $image->Get('width', 'height');
	return ($width, $height);
	undef $image;
}

# if a href.txt file exists in a directory, it's content
# shall be used to build the visible text part of a reference
sub gethreftext {

	my ($dir) = @_;
	my $content;
	my $file = $dir . '/' . 'href.txt';
	if (-f $file) {
		# open a file and print out it's content
		open(FROM, $file);
		while (<FROM>) {
			$content .= $_;
		}
		close(FROM);
	}
	$content;
}

# if a short.txt file exists in a directory, it's content
# might be used to build a decriptive text alongside of
# reference
sub getshorttext {

	my ($dir) = @_;
	my $content;
	my $file = $dir . '/' . 'short.txt';
	if (-f $file) {
		# open a file and print out it's content
		open(FROM, $file);
		while (<FROM>) {
			$content .= $_;
		}
		close(FROM);
	}
	$content;
}

# if a date.txt file exists in a directory, it's content
# might be used to build a decriptive date alongside of
# reference
sub getdatetext {

	my ($dir) = @_;
	my $content;
	my $file = $dir . '/' . 'date.txt';
	if (-f $file) {
		# open a file and print out it's content
		open(FROM, $file);
		while (<FROM>) {
			$content .= $_;
		}
		close(FROM);
	}
	$content;
}

sub getrefimage {

	my ($dir) = @_;
	my $imgfn;
	my $file = $dir . '/' . 'image.txt';
	if (-f $file) {
		# open a file and get it's content
		open(FROM, $file);
		while (<FROM>) {
			$imgfn .= $_;
		}
		close(FROM);
	}
	$imgfn;
}

# if a title.txt file exists in a directory, it's content
# might be used to build title text of the page build from
# that directory. this function has to ensure, that there is
# no html code inside (i.e. get all "<...>" and "&...;" out)
sub gettitletext {

	my ($dir) = @_;
}


sub DEFAULT {
	$a cmp $b;
}


sub REVERSE {
	$b cmp $a;
}


sub ISODATE_old {
	# an iso formatted date pattern (e.g. 2002-05-30)
	$isodatepat = '\d\d\d\d-\d\d-\d\d';
	# copy the global vars
	$ac = $a;
	$bc = $b;
	# grab the iso formatted date out
	$ac =~ s/.*($isodatepat).*/$1/;
	$bc =~ s/.*($isodatepat).*/$1/;
	$ac cmp $bc;
}


sub ISODATEREV_old {
print STDERR "$a||$b||";
	# an iso formatted date pattern (e.g. 2002-05-30)
	$isodatepat = '\d\d\d\d-\d\d-\d\d';
	# copy the global vars
	$ac = $a;
	$bc = $b;
	# grab the iso formatted date out
	$ac =~ s/.*($isodatepat).*/$1/;
	$bc =~ s/.*($isodatepat).*/$1/;
print STDERR "$ac||$bc||\n";
	$bc cmp $ac;
}


sub ISODATE {
#print STDERR "$a||$b||";
	# a and b are holding directory names
	# so look for the DATE.TXT file in there
	# if we found one, we replace the args by
	# it's content. otherwise we take the
	# directory name
	my $datetext;
	$datetext = getdatetext("$a");
	if ($datetext =~ /.+/) {
		$ac = $datetext;
	} else {
		$ac = $a;
	}
	$datetext = getdatetext("$b");
	if ($datetext =~ /.+/) {
		$bc = $datetext;
	} else {
		$bc = $b;
	}
	# an iso formatted date pattern (e.g. 2002-05-30)
	$isodatepat = '\d\d\d\d-\d\d-\d\d';
	# copy the global vars
	# grab the iso formatted date out
	$ac =~ s/.*($isodatepat).*/$1/;
	$bc =~ s/.*($isodatepat).*/$1/;
#print STDERR "$ac||$bc||\n";
	$ac cmp $bc;
}


# this new one grabs out first the DATE.TXT file
sub ISODATEREV {
#print STDERR "$a||$b||";
	my $datetext;
	$datetext = getdatetext("$a");
	if ($datetext =~ /.+/) {
		$ac = $datetext;
	} else {
		$ac = $a;
	}
	$datetext = getdatetext("$b");
	if ($datetext =~ /.+/) {
		$bc = $datetext;
	} else {
		$bc = $b;
	}
	$isodatepat = '\d\d\d\d-\d\d-\d\d';
	$ac =~ s/.*($isodatepat).*/$1/;
	$bc =~ s/.*($isodatepat).*/$1/;
#print STDERR "$ac||$bc||\n";
	$bc cmp $ac;
}


# build a default index from content of a directory
# at the time it is only regards other directories -
# following the strict design principle of one page
# euals to one directory.
# the routine might be called from nnn.exec.txt
# files installed by the web servant.
# if no nnn.xxx.txt file exists inside a directory
# it is called as a fallback by main()
sub autoindex {

	#my ($sortopt) = @_;
	my ($dirmatch, $max, $maxshort, $sortopt) = @_;
	
	#print $dirmatch;
	#print $maxshort;
	#print $sortopt;
	#print "\n";

	if ($dirmatch =~ /^$/) {
		$dirmatch = '*';
	}
	if ($max =~ /^$/) {
		$max = 9;
	}
	if ($maxshort =~ /^$/) {
		$maxshort = 3;
	}
	if ($sortopt =~ /^$/) {
		$sortopt = 'DEFAULT';
	}

	my @dircontent;
	my $direntry;
	
	#print $dirmatch;
	#print $maxshort;
	#print $sortopt;
	#print "\n";

	# get the list of files (entries) in "dir"
	@dircontent = glob $dirmatch;
	
	#print STDERR @dircontent;
	#print STDERR (sort $sortopt @dircontent);
	#print STDERR "================================================\n";
	
	my $maxcount = 0;
	my $shortcount = 0;
	
	# for every directory in it
	foreach $direntry (sort $sortopt @dircontent) {
	
		if (-d $direntry && $maxcount < $max) {
			# get reference text inside
			$hreftext = gethreftext("$direntry");
			# get reference date text inside
			$datetext = getdatetext("$direntry");
			# get reference short text inside
			$shorttext = getshorttext("$direntry");
			# get reference image inside
			$refimage = getrefimage("$direntry");
			
			print "<p>\n";
			
			print "<a href=\"$direntry\" class=\"indexheader\">";
			print "<font size=\"+1\">";
			if ($hreftext =~ /.+/) {
				print "$hreftext";
			} else {
				print "$direntry";
			}
			print "</font>";
			print "</a>\n";
			
			print "<br>\n";
			
			if ($datetext =~ /.+/) {
				print "<font size=\"-2\" class=\"date\">$datetext</font>\n";
			}
			
			print "<br>\n";
				
			if ($refimage =~ /.+/) {
				print "<a class=\"bordered-left\" href=\"$direntry\">";
				print "<img src=\"";
				print "$direntry/$refimage";
				print "\" border=\"0\" align=\"left\">";
				print "</a>";
			}

			if ($shortcount < $maxshort) {
				if ($shorttext =~ /.+/) {
					print "$shorttext\n";
					print " ";
					print "<span class=\"separator\">[</span><a href=\"$direntry\">goto</a><span class=\"separator\">]</span>";
					print "<BR clear=\"all\">";
				}
			}
			
			print "</p>\n";
			
			$maxcount++;
			$shortcount++;
		}
	}
}


# look for file in current directory and ascending the directory tree
# also look in every directory for the named file in subdir .common
# return the first file found and it's absolut path name

sub findfile {
	my ($file) = @_;
#print STDERR "searching for file: $file\n";
	my $dir;
	my $newdir;
	my $startdir;
	$dir = cwd;
	$startdir = $dir;
	chdir ($dir);
#print STDERR "starting in: $dir\n";
	while (-d $dir) {
		if (-f $file) {
#print STDERR "found: $dir/$file\n";
			chdir ($startdir);
			return "$dir/$file";
		}
		if (-d '../.common') {
		if (-f '../.common/' . $file) {
#print STDERR "found: $dir/../.common/$file\n";
			chdir ($startdir);
			return "$dir/../.common/$file";
		}
		}
		
		chdir ("$dir" . "/" . "..");
		$newdir = cwd;
		if ($newdir eq $dir) {
			chdir ($startdir);
			return "";
		} else {
#print STDERR "resuming in: $newdir\n";
			$dir = $newdir;
		}
	}
}

sub findfilerelativ {
	my ($file) = @_;
	my $dir;
	my $newdir;
	my $reldir;
	my $startdir;
	$dir = cwd;
	$startdir = $dir;
	$reldir = "";
	chdir ($dir);
	while (-d $dir) {
		if (-f $file) {
			chdir ($startdir);
			return "$reldir" . "$file";
		} else {
			# switch to next upper directory
			chdir ("$dir" . "/" . "..");
			$newdir = cwd;
		}
		# if we are already on top level, the chdir() has failed
		if ($newdir eq $dir) {
			chdir ($startdir);
			return "";
		} else {
			$reldir = $reldir . "../";
			$dir = $newdir;
		}
	}
}

sub title {
	my $sep = '::';
	my $title = cwd;
	$title =~ s/$basepath//;
	# get rid of a leading slash
	$title =~ s/^\///;
	# replace any orrurence of directory separation char by my string
	$title =~ s/[\/\\]/ $sep /g;
	print "$title";
}

# same literal string as in title function,
# but everything else than the current directory
# formatted as a clickable link

sub youarehere {
	my $sep = '::';
	my $dir = cwd;
	# get rid of the local directory portion in the path
	$dir =~ s/$basepath//;
	# get rid of a leading slash
	$dir =~ s/^\///;
	my $reldir = $dir;
#print STDERR "we are here: $reldir\n";
	# split up the rest
	@dirs = split (/\//,$reldir);
	# replace the firt elem by root name
	$dirs[0] = $rootname;
	# only if we are not on top level
	if ($#dirs > 0) {
		# we fill links from right to left
		$links[$#dirs-1] = "..";
		for ($i=$#dirs-2; $i>=0; $i--) {
			$links[$i] = ".." . "/" . "$links[$i+1]";
		}
		# but printing starts from the left
		for ($i=0; $i<$#dirs; $i++) {
			print "<a href=\"$links[$i]\">$dirs[$i]</a>\n";
			print "<span class=\"separator\">$sep</span>\n";
		}
	}
	# finally current directory (not a link)
	print "$dirs[$#dirs]";
}

sub from {
	my ($filename, $format) = @_;
	# open a file and print out it's content
	# on failure print out a red html warning
	open(FROM, $filename);
	while (<FROM>) {
		chomp();
		if ($format =~ /HTML/) {
			print $_;
			print "\n";
		} else {
			if (/^$/) {
				print "<p>\n";
			} else {
				print $_;
				if ($format =~ /PRE/) {
					print "<br>\n";
				}
			}
		}
	}
	close(FROM);
}

sub cont {
	my ($filename) = @_;
	my $content;
	# open a file and print out it's content
	# on failure print out a red html warning
	open(FROM, $filename);
	while (<FROM>) {
		$content .= $_;
	}
	close(FROM);
	$content;
}

sub thumbnail {
	my ($filename) = @_;
	# thumbnal file name is standardized
	# return the name if file exists
	# otherwise return original name
	$thumbnail = "tn_" . $filename;
	if (-f $thumbnail) {
		return $thumbnail;
	} else {
		return $filename;
	}
}

sub warning {
	 # print out a red html warning message
}

sub _print_table_row
{
	$last = @_ - 1;
	print "<tr>";
	foreach ( 0 .. $last ) {
		print "<td>@_[$_]</td>";
	}
	print "</tr>\n";
}	

$delimiter = ':';
sub table_simple {
	my $filename = @_;
	open(TABLE, $filename);
	print "<table>";
	while ($line = <table>) {
		chomp($line);
		# split up line into its fields by delim character
		@line = split(/$delimiter/,$line);
		# if more columns than last line increase count
		print "<tr>";
		foreach $cell (@line) {
			print "<td>$cell</td>";
		}
		print "</tr>\n";
	}
	print "</table>\n";
	close(TABLE);
}


sub list {
	my ($filename, $listtype) = @_;
	open(LIST, $filename);
	print "<$listtype>";
	my $line_count = 0;
	while ($line = <LIST>) {
		chomp($line);
		print "<li>$line</li>";
		$line_count++;
	}
	print "</$listtype>\n";
	close(LIST);
}

@trclass = ("odd","even");
sub table {
	my ($filename, $class, $celldelimiter, $textdelimiter) = @_;
	open(TABSRC, $filename);
	#if ($class =~ /^$/) {
	#	print "<table class=\"ranking\" cellpadding=\"2\" cellspacing=\"1\">";
	#} else {
		#print "<table class=\"$class\">";
	#}
	print "<table class=\"$class\" cellpadding=\"2\" cellspacing=\"1\">";
	my $line_count = 0;
	while ($line = <TABSRC>) {
		chomp($line);
		# split up line into its fields by delim character
		@line = split(/$celldelimiter/,$line);
		#$length = @line;
		#print "$length\n";
		# if more columns than last line increase count
		#&_print_table_row(@line);
		$odd = $line_count % 2;
		print "<tr class=\"$trclass[$odd]\">";
		foreach $cell (@line) {
			# remove leading and trailing text delimiter characters
			#$cell =~ /^$textdelimiter//; # correct code?
			#$cell =~ /^$textdelimiter//; # correct code?
			#if ($cell =~ /^$/) {
			#	$cell = "&nbsp;";
			#}
			print "<td>$cell</td>";
		}
		print "</tr>\n";
		$line_count++;
	}
	print "</table>\n";
	close(TABSRC);
}



BEGIN {
	$rootdir = findfile('root.txt');
	$rootname = cont($rootdir);
#print STDERR "root: $rootname\n";
	$rootdir =~ s/root.txt//;
#print STDERR "rootdir: $rootdir\n";
	$basepath = dirname($rootdir);
#print STDERR "basepath: $basepath\n";
}

END {}

# satisfy caller
1;
