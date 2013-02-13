#!/usr/bin/perl

$tbrutas = 0;
$tdirus = 0;
while (<>) {
    chomp;	# strip record separator
    if (/Accepted /) {
	if (($_ =~ / for [^ ]* / &&

	  ($RLENGTH = length($&), $RSTART = length($`)+1)) >= 0) {
	    $us = substr($_, $RSTART + 4, $RLENGTH - 6);
	    $accus{$us}++;
	    $_ =~ / from [0-9.]* / &&

	      ($RLENGTH = length($&), $RSTART = length($`)+1);
	    $ip = substr($_, $RSTART + 5, $RLENGTH - 7);
	    $accip{$ip}++;
	    $accusip{$us . " " . $ip}++;
	}
    }

    if (/Failed password for /) {
	$_ =~ / from [0-9.]* / &&

	  ($RLENGTH = length($&), $RSTART = length($`)+1);
	$ip = substr($_, $RSTART + 5, $RLENGTH - 7);
	if (($_ =~ / invalid user / &&

	  ($RLENGTH = length($&), $RSTART = length($`)+1)) > 0) {
	    $brutaip{$ip}++;
	    $tbrutas++;
	}
	else {
	    $_ =~ / for [^ ]* / &&

	      ($RLENGTH = length($&), $RSTART = length($`)+1);
	    $us = substr($_, $RSTART + 4, $RLENGTH - 6);
	    $dirip{$ip}++;
	    $dirus{$us}++;
	    $dirigido{$us . " " . $ip}++;
	    $tdirus++;
	}
    }
}

print "Usuarios con ingresos exitosos\n";
foreach $key (sort { $accus{$b} <=> $accus{$a} } keys %accus) {
	printf "%5d %s\n", $accus{$key}, $key;
}

print "IPs desde las cuales se han intentado ingresos a usuarios inexistentes ($tbrutas):\n";
foreach $key (sort { $brutaip{$b} <=> $brutaip{$a} } keys %brutaip) {
	printf "%5d %s\n", $brutaip{$key}, $key;
}

print "Usuarios validos con ingresos fallidos ($tdirus):\n";
foreach $key (sort { $dirus{$b} <=> $dirus{$a} } keys %dirus) {
	printf "%5d %s\n", $dirus{$key}, $key;
}

print "IPs desde las que hay ingresos fallidos a usuarios validos:\n";
foreach $key (sort { $dirip{$b} <=> $dirip{$a} } keys %dirip) {
	printf "%5d %s\n", $dirip{$key}, $key;
}

print "Usuario validos e IP ingresos fallidos:\n";
foreach $key (sort { $dirigido{$b} <=> $dirigido{$a} } keys %dirigido) {
	printf "%5d %s\n", $dirigido{$key}, $key;
}

