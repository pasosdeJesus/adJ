/^!!*/ {
	gsub(/^!!*/, "", $0);

}

/%%%$/ {
	gsub(/%%%$/, "", $0);
}

/==/ {
	gsub(/==/, "", $0);
}

/<pre>/ {
	gsub(/<pre>/, "", $0);
	estpre=1;
}

/<\/pre>/ {
	gsub(/<\/pre>/, "", $0);
	estpre=0;
}


/\[.*\|.*\]/ {
	if (match($0, / *\|.*\]/)>0) {
		s=substr($0, RSTART+1, RLENGTH-2);
		if (substr(s, 1, 6) == "mailto") {
			$0 = substr($0, 1, RSTART-1) ": " substr(s,8) substr($0, RSTART+RLENGTH, length($0)-RSTART-RLENGTH);
		} else {
			$0 = substr($0, 1, RSTART-1) "]" substr($0, RSTART+RLENGTH, length($0)-RSTART-RLENGTH);
		}
	}
}

/.*/ {
	r=$0;
	##print "OJO ini r=" r;
	ind="";
	if (estpre == 1) {
		print r;
	} else {
		if (length(r)>3 && substr(r, 1, 3) == "** ") {
			r = "  - " substr(r, 4);
			ind="    ";
		} else if (length(r)>2 && substr(r, 1, 2) == "* ") {
			ind="  ";
		}
		while (length(r)>72) {
			p=1;
			uea = 0; uet = 0;
			while (p<length(r) && uet == 0) 	{
				##print "OJO p=" p;
				c = substr(r, p, 1);
				##print "OJO c=" c;
				if (c == " " || c == "\t") {
					if (p<=72) {
						uea = p;
					} else if (uet == 0) {
						uet = p;
					}
				}
				p++;
			}
			if (uet == 0) {
				uet = p;
			}
			#print "OJO uea=" uea " uet=" uet " r=" r;
			if (uea < 5 && uet - uea > 70 ) {
				a = substr(r, 1, uet);
				r = ind substr(r, uet+1);
			} else	if (uea > 0) {
				a = substr(r, 1, uea);
				r = ind substr(r, uea+1);
			} else {
				a = r;
				r = "";
			}
			#print "OJO a=" a;
			#print "OJO r=" r;
			print a;
		}
		print r;
	}
}

