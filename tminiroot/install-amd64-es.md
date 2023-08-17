#     $OpenBSD: install.md,v 1.59 2023/03/07 17:29:42 kn Exp $
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

MDKERNEL=APRENDIENDODEJESUS
MDBOOTSR=y
MDXAPERTURE=2
MDXDM=y
NCPU=$(sysctl -n hw.ncpufound)

if dmesg | grep -q 'efifb0 at mainbus0'; then
	MDEFI=y
fi

md_installboot() {
	if ! installboot -r /mnt ${1}; then
		echo "\nFalla al instalar bloques de arranque."
		echo "No podra arrancar OpenBSD de ${1}."
		exit
	fi
}

md_prep_fdisk() {
	local _disk=$1 _q _d

	while :; do
		_d=editar
		_q="Usar (T)odo el disco MBR, todo el disco (G)PT"

		[[ $MDEFI == y ]] && _d=gpt

		if disk_has $_disk mbr || disk_has $_disk gpt; then
			fdisk $_disk
			if disk_has $_disk mbr openbsd ||
				disk_has $_disk gpt openbsd; then
				_q="$_q, area de (O)penBSD,"
				_d=OpenBSD
			fi
		else
			echo "No hay un RAM o un GPT valido."
		fi

		ask "$_q o (E)ditar?" "$_d"
		case $resp in
		[tT]*)
			echo -n "Estableciendo particion de OpenBSD en RMA como el disco $_disk completo..."
			fdisk -iy $_disk >/dev/null
			echo "listo."
			return ;;
		[gG]*)
			if [[ $MDEFI != y ]]; then
				ask_yn "Un disco EFI/GPT podria no arrancar. Proceder?"
				[[ $resp == n ]] && continue
			fi

			echo -n "Estableceendo la particion OpenBSD GPT para el disco completo $_disk..."
			fdisk -gy -b 532480 $_disk >/dev/null
			echo "listo."
			return ;;
		[eE]*)
			if disk_has $_disk gpt; then
				# Manually configure the GPT.
				cat <<__EOT

Ahora creara dos particiones GPT. La primera debe tener una identificacion
'EF' y ser suficientemente grande para los programas de arranque de OpenBSD,
al menos 532480 bloques. La segunda debe tener identificacion 'A6' y
contendra sus datos de OpenBSD. Una particion no puede traslaparse con la otra.
Dentro de la orden fdisk , la orden 'manual' describe las ordenes
de fdisk en detalle.

$(fdisk $_disk)
__EOT
				fdisk -e $_disk

				if ! disk_has $_disk gpt openbsd; then
					echo -n "No hay particion OpenBSD en GPT,"
				elif ! disk_has $_disk gpt efisys; then
					echo -n "No hay particion EFI Sys en GPT,"
				else
					return
				fi
			else
				# Manually configure the MBR.
				cat <<__EOT


Ahora creara una sola particion en el RMA que con todos sus datos de OpenBSD
Esta particion debe tener identificacion 'A6'; *NO* debe traslaparse con otras
particiones y debe marcarse como la unica particion activa.  En el programa
fdisk, la orden 'manual' describe todas las ordenes de fdisk en detalle.

$(fdisk $_disk)
__EOT
				fdisk -e $_disk
				disk_has $_disk mbr openbsd && return
				echo -n "No hay particion OpenBSD en el RMA (MBR),"
			fi
			echo " intente nuevamente." ;;
		[oO]*)
			[[ $_d == OpenBSD ]] || continue
			if [[ $_disk == $ROOTDISK ]] && disk_has $_disk gpt &&
				! disk_has $_disk gpt efisys; then
				echo "No hay particion EFI Sys en GPT, intente nuevament."
				$AUTO && exit 1
				continue
			fi
			return ;;
		esac
	done
}

md_prep_disklabel() {
	local _disk=$1 _f=/tmp/i/fstab.$1

	md_prep_fdisk $_disk

	disklabel_autolayout $_disk $_f || return
	[[ -s $_f ]] && return

	# Edit disklabel manually.
	# Abandon all hope, ye who enter here.
	disklabel -F $_f -E $_disk
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
