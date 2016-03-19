#!/bin/sh
# Inicia instalación de adJ preferiblemente en terminal UTF8

if (test "$XTERM_SHELL" != "") then {
	w=`whoami`
	if (test "$w" = "root" -o "$SUDO_USER" != "") then {
		LANG=es_CO.UTF8 xterm -en utf8 -u8 -e "ADMADJ=$USER ARCH=$ARCH /usr/local/adJ/inst-adJ.sh" 2> /dev/null
	} else {
		LANG=es_CO.UTF8 xterm -en utf8 -u8 -e "echo -n 'Clave de la cuenta root - ';su -l root -c 'ADMADJ=$USER ARCH=$ARCH /usr/local/adJ/inst-adJ.sh'" 2> /dev/null
	} fi;	
} else {
	if (test "$w" = "root" -o "$SUDO_USER" != "") then {
		LANG=es_CO.UTF8 ARCH=$ARCH ADMADJ=$USER /usr/local/adJ/inst-adJ.sh
	} else {
		echo -n "Clave de la cuenta root - ";
		LANG=es_CO.UTF8 su -l root -c "ADMADJ=$USER ARCH=$ARCH /usr/local/adJ/inst-adJ.sh"
	} fi;
} fi;
