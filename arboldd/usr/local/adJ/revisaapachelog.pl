#!/usr/bin/perl

$md{"Jan"} = "01";
$md{"Feb"} = "02";
$md{"Mar"} = "03";
$md{"Apr"} = "04";
$md{"May"} = "05";
$md{"Jun"} = "06";
$md{"Jul"} = "07";
$md{"Aug"} = "08";
$md{"Sep"} = "09";
$md{"Oct"} = "10";
$md{"Nov"} = "11";
$md{"Dec"} = "12";

$tbrutas = 0;
$tdirus = 0;
while (<>) {
	chomp;	# strip record separator
	if (/^[0-9]+.[0-9]+.[0-9]+.[0-9]+ /) {
		$ip = substr($&, 0, length($&) - 1);
		#print $ip;
		$accip{$ip}++;
		#print " " . $accip{$ip};
		if ($_ =~ /\[[0-9][0-9]\/[A-Z][a-z][a-z]\/[0-9][0-9][0-9][0-9]:/) {
			$dia = substr($&, 1, 2);
			$mesl = substr($&, 4, 3);
			$mes = $md{$mesl};
			$anio = substr($&, 8, 4);
			$fecha = $anio . "-" . $mes . "-" . $dia;
			#print " " . $fecha;
			if ($fecha > $maxfip{$ip}) {
				$maxfip{$ip} = $fecha;
			}
			#print " " . $maxfip{$ip};
		}
		$tip++;
		#print " " . $tip . "\n";
	}
}

print "IPs con accesos y acceso más reciente (" . (scalar keys %accip) . "):\n";
foreach $key (sort { $accip{$b} <=> $accip{$a} } keys %accip) {
	printf "%5d %s %s\n", $accip{$key}, $key, $maxfip{$key};
}

