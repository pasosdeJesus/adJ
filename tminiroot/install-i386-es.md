#      $OpenBSD: install.md,v 1.54 2011/07/06 20:02:16 halex Exp $
#
#
# Copyright (c) 1996 The NetBSD Foundation, Inc.
# All rights reserved.
#
# This code is derived from software contributed to The NetBSD Foundation
# by Jason R. Thorpe.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE NETBSD FOUNDATION, INC. AND CONTRIBUTORS
# ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
# TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
#
# machine dependent section of installation/upgrade script.
#

MDXAPERTURE=2
MDXDM=y
NCPU=$(sysctl -n hw.ncpufound)

((NCPU > 1)) && { DEFAULTSETS="bsd bsd.rd bsd.mp" ; SANESETS="bsd bsd.mp" ; }

md_installboot() {
	cat /usr/mdec/boot >/mnt/boot
	if ! /usr/mdec/installboot /mnt/boot /usr/mdec/biosboot ${1} ; then
		echo "\nFalla al instalar bloques de arranque."
		echo "No podra arrancar OpenBSD de ${1}."
		exit
	fi
}

md_prep_fdisk() {
	local _disk=$1 _q _d

	while :; do
		_d=editar
		if [[ -n $(fdisk $_disk | grep 'Signature: 0xAA55') ]]; then
			fdisk $_disk
			if [[ -n $(fdisk $_disk | grep '^..: A6 ') ]]; then
				_q=", usar el área de (O)penBSD,"
				_d=OpenBSD
			fi
		else
			echo "El RMA (Registro maestro de arranque MBR) tiene firma invalida; no se muestra."
		fi
		ask "¿Usar (T)odo el disco $_q o (E)ditar RMA?" "$_d"
		case $resp in
		t*|T*)
			echo -n "Estableciendo partición de OpenBSD en RMA como el disco $_disk completo..."
			fdisk -e ${_disk} <<__EOT >/dev/null
reinit
update
write
quit
__EOT
			echo "listo."
			return ;;
		e*|E*)
			# Manually configure the MBR.
			cat <<__EOT

Ahora creará una sola partición en el RMA que con todos sus datos de OpenBSD
Esta partición debe tener identificación 'A6'; *NO* debe traslaparse con otras
particiones y debe marcarse como la única partición activa.  En el programa
fdisk, el comando 'manual' describe todos los comandos de fdisk en detalle.

$(fdisk ${_disk})
__EOT
			fdisk -e ${_disk}
			[[ -n $(fdisk $_disk | grep ' A6 ') ]] && return
			echo "No hay partición para OpenBSD en el RMA, intente de nuevo." ;;
		o*|O*)	return ;;
		esac
	done
}

md_prep_disklabel() {
	local _disk=$1 _f _op

	md_prep_fdisk $_disk

	_f=/tmp/fstab.$_disk
	if [[ $_disk == $ROOTDISK ]]; then
		while :; do
			echo "La distribución autolocalizada para $_disk es:"
			disklabel -h -A $_disk | egrep "^#  |^  [a-p]:"
			ask "Usar distribución (A)utolocalizada, (E)ditarla, o (C)rear una distribución?" a
			case $resp in
			a*|A*)	_op=-w ; AUTOROOT=y ;;
			e*|E*)	_op=-E ;;
			c*|C*)	break ;;
			*)	continue ;;
			esac
			disklabel $FSTABFLAG $_f $_op -A $_disk
			return
		done
	fi

	cat <<__EOT

Ahora creará subparticiones para OpenBSD en la partición del RMA para OpenBSD.
Las subparticiones definen como se divide la partición RMA en 
espacios donde se crearán los sistemas de archivo y el area de intercambio.
En este programa debe proveer para cada sistema de archivo un punto de montaje.

Los desplazamientos usados para las subparticiones son ABSOLUTAS, i.e relativas
al comienzo del disco, NO al comienzo de la partición para OpenBSD el RMA.

__EOT

	disklabel $FSTABFLAG $_f -E $_disk
}

md_congrats() {
}

md_consoleinfo() {
	local _u _d=com

	for _u in $(scan_dmesg "/^$_d\([0-9]\) .*/s//\1/p"); do
		if [[ $_d$_u == $CONSOLE || -z $CONSOLE ]]; then
			CDEV=$_d$_u
			CPROM=com$_u
			CTTY=tty0$_u
			return
		fi
	done
}
