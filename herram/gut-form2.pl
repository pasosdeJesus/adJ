#!/usr/bin/perl
# Second stage of indentation to format text like Bibles in project Gutenberg
# First stage is output from gut-form1.awk
# Released to the public domain. 2003. No warranties. vtamara@users.sourceforge.net

$ind="        ";
$intext=0;
$surl="";
while (<>) {
	if (/^1[ ]$/) {
		$intext=1;
	}
	if (/^------------$/) {
		$intext=0;
	}
	if ($intext eq 1) {
		$ini=$ind;
		if (/^[0-9]+:[0-9]+/) {
			$ini="";
		}
		$r=$_;
		$l="";
		while ($r =~ /([^ ]*[ ]*) ([^ ].*)/) {
			if (length($1)+length($l)>69) {
				print $l."\n";
				$l=$ind.$1;
			}
			elsif ($l eq "") {
				$l=$ini.$1;
			}
			else {
				$l=$l." ".$1;
			}
			$r=$2;
		}
		if (length($l)+length($r)>69) {
			print $l."\n";
			print $ind.$r."\n";
		}
		else {
			print $l." ".$r."\n";
		}
	}
	elsif (/^(.*)(http:[^ ]*)\n/) {
		print $1."\n";
		$surl=$2;
	}
	elsif ($surl ne "") {
		/^([^ ]*)(.*)/;
		print $surl.$1."\n";
		print $2."\n";
		$surl="";
	}
	else {
		print $_;
	}
}
