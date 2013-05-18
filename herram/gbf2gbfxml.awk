#/usr/bin/awk -f
# Script to translate from GBF to GBF in XML
# This source is released to the public domain since 2002.
# vtamara@informatik.uni-kl.de

# Missing features
# The same mentioned in gbfxml.dtd

function str_from(str,i) {
	return substr(str,i,length(str)-i+1);
}

function start_cm(att,r) {
	tag="";
	if (opened_pp==1) {
		tag="cm";
	}
	else if (opened_sc==1) {
		tag="cm";
	}
	if (opened_cm==1 && tag=="") {
		print FNR ": Cannot determine tag for <CM>";
		exit 1;
	}
	otop=""; 
	otcl="";
	if (opened_fr==1) {
		otcl="</fr>";
		otop="<fr>";
	}
	if (muss_open_fr==1) {
		otop="<fr>";
		muss_open_fr=0;
		opened_fr=1;
	}
	if (opened_cm==1) {
		print otcl "</" tag ">";
	}
	if (tag!="") {
		opened_cm=1;
		c="<" tag;
		if (att!="") {
			c=c " " att;
		}
		c=c ">" otop;
		paragraph=r;
		print c r;
	}
}

function end_cm() {
	tag="";
	if (opened_pp==1) {
		tag="cm";
	}
	else if (opened_sc==1) {
		tag="cm";
	}
	otcl="";
	if (opened_fr==1) {
		otcl="</fr>";
		opened_fr=0;
		muss_open_fr=1;
	}
	paragraph="";
	print otcl "</" tag ">";
	opened_cm=0;
}

/^H0[^>]*>/ {

	print "<!DOCTYPE gbfxml PUBLIC \"-//Jesus Nos Ama//DTD General Bible Format XML 1.0\" \"gbfxml.dtd\">";
	match($0,/^H0[^>]*>/);
	print "<gbfxml version=\"" substr($0,3,RLENGTH-3) "\">";
	opened_gbf=1;
	if (match($0,/^H0[^>]*>[ ]*$/)==0) {
		print FNR ": No text expected after H0xx";
		exit 1;
	}

}

/^H1>/ {
	r=str_from($0,4);
	if (r=="") {
		print FNR ": Text expected after H1";
		exit 1;
	}
	print "<tt>" r "<t lang=\"es\"></t></tt>"; 
}

/^H2>/ {
	r=str_from($0,4);
	if (r=="") {
		print FNR ": Text expected after H2";
		exit 1;
	}

	print "<stt>" r "<t lang=\"es\"></t></stt>"; 
}

/^H3>/ {
	r=str_from($0,4);
	if (r=="") {
		print FNR ": Text expected after H3";
		exit 1;
	}

	print "<sumrights>" r "<t lang=\"es\"></t></sumrights>"; 
}

/^H4>/ {
	r=str_from($0,4);
	if (r=="") {
		print FNR ": Text expected after H4";
		exit 1;
	}

	print "<rights>" r "<t lang=\"es\"></t></rights>"; 
}

/^B[0ACINOP]>/ {
	sb_type=substr($0,1,2);
	if (match($0,/^B[OACINOP]>[ ]*$/)==0) {
		print FNR ": No text expected after " sb_type "\n" $0;
		exit 1;
	}
}

# Subbook in psalms
/^TB>/ {
	if (opened_sb!=1) {
		print FNR ": Expected SB before tb";
		exit 1;
	}
	if (opened_cm==1) {
		end_cm();
	}
	if (opened_sc==1) {
		print "</sc>";
		opened_sc=0;
	}
	if (opened_tb==1) {
		print "</tb>";
		opened_tb=0;
	}
	r=str_from($0,4);
	if (r=="") {
		print FNR ": Text expected after TB";
		exit 1;
	}
	opened_tb=1;
	print "<tb><tt>" r "<t lang=\"es\"></t></tt>";
}

/^Tb>/ {
	if (opened_tb!=1) {
		print FNR ": Expected TB before Tb";
		exit 1;
	}
	if (match($0,/^Tb>[ ]*$/)==0) {
		print FNR ": No text expected after Tb";
		exit 1;
	}
}

/^SB[^>]*>/ {
	if (opened_cm==1) {
		end_cm();
	}
	if (opened_sc==1) {
		print "</sc>";
		opened_sc=0;
		last_sc=0;
	}
	if (opened_tb==1) {
		print "</tb>";
		opened_tb=0;
	}
	if (opened_sb==1) {
		print "</sb>";
	}
	opened_sb=1;
	match($0,/^SB[^>]*>/);
	idsb=substr($0,RSTART+2,RLENGTH-3)
	if (substr($0,RSTART+2,1)>="0" && substr($0,RSTART+2,1)<="9") {
		idsb="b" idsb;
	}
	gsub(/ /,"-",idsb);
	r="<sb id=\"" idsb  "\"";
	if (sb_type!="") {
		r=r " type=\"" sb_type "\"";
	}
	sb_type="";
	r=r ">";
	print r;

	if (match($0,/^SB[^>]*>[ ]*$/)==0) {
		print FNR ": No text expected after SB";
		exit 1;
	}
	last_sc=0;
}


# Chapter 
/^SC[^>]*>/ {
	if (opened_tb!=1 && opened_sb!=1) {
		print FNR ": SC should be after TB or SB";
		exit 1;
	}
	if (opened_pp==1) {
		print FNR ": Missing Pp before SC";
		exit 1;
	}
	if (opened_cm==1) {
		end_cm();
	}
	if (opened_sc==1) {
		print "</sc>";
	}
	opened_sc=1;
	if (match($0,/^SC[^>]*>/)==0) {
		print FNR ": Missing identifier in SC";
		exit 1;
	}
	idsc=substr($0,RSTART+2,RLENGTH-3)
	r="<sc num=\"" idsc "\" id=\"" idsb "-" idsc  "\">";
	print r;
	if (last_sc>0 &&  idsc!=last_sc+1) {
		print FNR ": Wrong enumeration of SC: " idsc ", previous: " last_sc;
		exit 1;
	}
	last_sc=idsc;
	last_sv=0;
}

# Title of section in Chapter
/^TS>/ {

	if (opened_sc!=1) {
		print FNR ": TS should be after SC";
		exit 1;
	}
	if (opened_cm!=1) {
		end_cm();
	}
	r=str_from($0,4);
	if (r=="") {
		print FNR ": Text expected after TS";
		exit 1;
	}
	print "<tt type=\"ts\">" r "<t lang=\"es\"></t></tt>";
}

/^Ts>/ {
}

# Possible title of chapter
/^TH>/ {
	if (opened_sc!=1) {
		print FNR ": TH expected after SC";
		exit 1;
	}
	if (opene_cm!=1) {
		start_cm("","");
	}
		
	r=str_from($0,4);
	if (r=="") {
		print FNR ": Text expected after TH";
		exit 1;
	}
	print "<tt type=\"th\">" r "<t lang=\"es\"></t></tt>"; 
}

/^Th>/ {
}

# Title of Book
/^TT>/ {
	if (opened_sb!=1) {
		print FNR ": TT expected after SB";
		exit 1;
	}
	r=str_from($0,4);
	if (r=="") {
		print FNR ": Text expected after TH";
		exit 1;
	}
	print "<tt>" r "<t lang=\"es\"></t></tt>"; 
}

/^Tt>/ {
}

# Comment 
/^TC>/ {
	if (opened_sc!=1) {
		print FNR ": TC expected after SC";
		exit 1;
	}
	r=str_from($0,4);
	if (r=="") {
		print FNR ": Text expected after TC";
		exit 1;
	}
	print "<tc>" r "<t lang=\"es\"></t></tc>"; 
}

/^Tc>/ {
}

# Paragraph
/^CM>/ {
	start_cm("", str_from($0,4));
}

# Direction
/^D[LRT]>/ {
	if (opened_cm==1) {
		end_cm();
	}
	r=str_from($0,4);
	start_cm(" type=\"" substr($0,1,2) "\"", r);
}

# Justification
/^J[CFLR]>/ {
	if (opened_cm==1) {
		end_cm();
	}
	r=str_from($0,4);
	start_cm(" type=\"" substr($0,1,2) "\"", r);
}

# Indente quote
/^PI>/ {
	if (opened_cm==1) {
		end_cm();
	}
	r=str_from($0,4);
	start_cm("type=\"" substr($0,1,2) "\">", r);
}

# Font attributes
/^F[BCIOSUV]>/ {
	if (opened_cm!=1) {
		start_cm("","");
	}
	r=str_from($0,4);
	tag=tolower(substr($0,1,2));
	print "<" tag ">" r "<t lang=\"es\"></t></" tag ">";
}


# Words of Jesus
/^FR/ {
	if (opened_cm!=1) {
		start_cm("","");
	}
	r=str_from($0,4);
	if (opened_fr!=0) {
		print FNR ": previous FR (line " lastfrline ") not closed";
		exit 1;
	}
	lastfrline=FNR;
	opened_fr=1;
	print "<fr>" r
}

/^Fr/ {
	if (muss_open_fr!=1 && opened_fr!=1) {
		print FNR ": FR was not opened";
		exit 1;
	}
	opened_fr=0;
	r=str_from($0,4);
	if (muss_open_fr==0) {
		print "</fr>" r;
	}
	else {
		print  r;
	}
	muss_open_fr=0;
}
# Verse
/^SV[^>]*>/ {
	if (opened_cm!=1) {
		start_cm("","");
	}
	match($0,/^SV[^>]*>/);
	idsv=substr($0,3,RLENGTH-3)
	print "<sv num=\"" idsv "\" id=\"" idsb "-" idsc "-" idsv  "\"/>";
	r=str_from($0,RLENGTH+1);
	print r;
	if (last_sv>0 &&  idsv!=last_sv+1) {
		print FNR ": Wrong enumeration of SV: " idsv ", previous: " last_sv;
		exit 1;
	}
	last_sv=idsv;

}

# Break line
/^CL>/ {
	if (opened_cm!=1) {
		start_cm("","");
	}
	r=str_from($0,4);
	print "<cl/>" r;
}

# Poetry
/^PP>/ {
	if (opened_pp==1) {
		print FNR ": Previous PP not closed";
		exit 1;
	}

	if (opened_cm!=1) {
		start_cm("","");
	}
	opened_pp=1;
	paragraph=str_from($0,4);
	otop="";
	otcl="";
	if (opened_fr==1) {
		otcl="</fr>";
		otop="<fr>";
	}
	print otcl "<pp><cm>" otop paragraph;
}

/^Pp>/ {
	if (opened_pp!=1) {
		print FNR ": End of poetry expected after PP";
		exit 1;
	}
	if (opened_cm==1) {
		end_cm();
	}
	opened_pp=0;
	r=str_from($0,4);
	print "</pp>" r;
	opened_cm=1;
}

# Footnote
/^RB>/ {
	if (opened_cm!=1) {
		start_cm("","");
	}
	if (opened_rb==1) {
		print FNR ": Previous RB was not closed";
		exit 1;
	}
	opened_rb=1;
	r=str_from($0,4);
	print "<rb>" r;
}

/^RF>/ {
	if (opened_rb==0) {
		print "<rb>";
	}
	r=str_from($0,4);
	print "<t lang=\"es\"></t><rf>" r "<t lang=\"es\"></t></rf>";
	print "</rb>";
	opened_rb=0;
}

/^Rf>/ {
	r=str_from($0,4);
	print r;
}

# Word Information
/^W[GHIT][^>]*>/ {
	if (opened_cm!=1) {
		start_cm("","");
	}
	match($0,/^W[GHIT][^>]*>/);
	r=str_from($0,RLENGTH+1);
	print "<wi type=\"" substr($0,2,1) "\">" substr($0,3,RLENGTH-3) "</wi>" r;
}

# Date 
/^SD[0-9][0-9][0-9][0-9]>/ {
	if (opened_cm!=1) {
		start_cm("","");
	}
	r=str_from($0,RLENGTH+1);
	print "<sd month=\"" substr($0,3,2) "\" day=\"" substr($0,5,2) "\"/>" r;
}

# Parallel Passage and cross reference
/^R[PX]seq [^ ]* [^:]*:[^>]*>/ {
	tag=substr($0,1,4);
	if (opened_cm!=1) {
		start_cm("","");
	}	
	match($0,/^R[PX]seq [^ ]*/);
	book=substr($0,7,RLENGTH-7);
	ll=RLENGTH;
	match($0,/^R[PX]seq [^ ]* [^:]:/);
	ch=substr($0,ll,RLENGTH-ll-1);
	ll=RLENGTH;
	match($0,/^R[PX]seq [^ ]* [^:]:[^>]*>/);
	vs=substr($0,ll,RLENGTH-ll-1);
	print "<" tolower(tag) " book=\"" book "\" ch=\"" ch "\" vs=\"" vs "\"/>";
}


BEGIN {
	print "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>";
	RS="<";
	opened_cm=0;
	opened_sb=0;
	last_sc=0;
	last_sv=0;
}

END {
	if (opened_cm==1) {
		end_cm();
	}
	if (opened_tb==1) {
		print "</tb>";
		opened_tb=0;
	}
	if (opened_sc==1) {
		print "</sc>";
		opened_sc=0;
	}
	if (opened_sb==1) {
		print "</sb>";
		opened_sb=0;
	}
	if (opened_gbf==1) {
		print "</gbfxml>";
		opened_gbf=0;
	}
}
