#!/bin/ksh
#	$OpenBSD: install.sh,v 1.225 2011/07/24 15:33:41 fgsch Exp $
#	$NetBSD: install.sh,v 1.5.2.8 1996/08/27 18:15:05 gwr Exp $
#
# Copyright (c) 1997-2009 Todd Miller, Theo de Raadt, Ken Westerback
# All rights reserved.
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
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
# NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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

MODE=install

. install.sub

DISK=
DISKS_DONE=
_DKDEVS=$(get_dkdevs)

rm -f /tmp/fstab.shadow /tmp/fstab /tmp/fstab.*

ask_yn "Use DUIDs rather than device names in fstab?" yes
[[ $resp == y ]] && FSTABFLAG=-F

while :; do
	DISKS_DONE=$(addel "$DISK" $DISKS_DONE)
	_DKDEVS=$(rmel "$DISK" $_DKDEVS)

	if isin $ROOTDISK $_DKDEVS; then
		resp=$ROOTDISK
		rm -f /tmp/fstab
	else
		ask_which "disk" "do you wish to initialize" \
			'$(l=$(get_dkdevs); for a in $DISKS_DONE; do
				l=$(rmel $a $l); done; bsort $l)' \
			done
		[[ $resp == done ]] && break
	fi

	DISK=$resp
	makedev $DISK || continue

	rm -f /tmp/*.$DISK
	AUTOROOT=n
	md_prep_disklabel $DISK || { DISK= ; continue ; }

	grep -qs " / ffs " /tmp/fstab.$ROOTDISK || \
		{ DISK= ; echo "'/' must be configured!" ; continue ; }

	if [[ -f /tmp/fstab.$DISK ]]; then
		while read _pp _mp _rest; do
			if [[ $_mp == "none" ]]; then
				echo "$_pp $_mp $_rest" >>/tmp/fstab
				continue
			fi
			[[ /tmp/fstab.$DISK == $(grep -l " $_mp " /tmp/fstab.*) ]] || \
				{ _rest=$DISK ; DISK= ; break ; }
		done </tmp/fstab.$DISK
		if [[ -z $DISK ]]; then
			cat /tmp/fstab.$_rest >/etc/fstab
			rm /tmp/fstab.$_rest
			set -- $(grep -h " $_mp " /tmp/fstab.*[0-9])
			echo "$_pp and $1 can't both be mounted at $_mp."
			continue
		fi
		_i=${#_fsent[*]}
		while read _pp _mp _fstype _rest; do
			[[ $_fstype == ffs ]] || continue
			_OPT=
			[[ $_mp == / ]] && _OPT=$MDROOTFSOPT
			newfs -q $_OPT ${_pp##/dev/}
			_fsent[$_i]="$_mp!$_pp"
			: $(( _i += 1 ))
		done </tmp/fstab.$DISK
	fi
done

for _mp in $(bsort ${_fsent[*]}); do
	_pp=${_mp##*!}
	_mp=${_mp%!*}
	echo -n "$_pp $_mp ffs rw"

	[[ $_mp == / ]] && { echo " 1 1" ; continue ; }

	echo -n ",nodev"

	case $_mp in
	/sbin|/usr)			;;
	/usr/bin|/usr/sbin)		;;
	/usr/libexec|/usr/libexec/*)	;;
	/usr/local|/usr/local/*)	;;
	/usr/X11R6|/usr/X11R6/bin)	;;
	*)	echo -n ",nosuid"	;;
	esac
	echo " 1 2"
done >>/tmp/fstab

munge_fstab
mount_fs "-o async"

install_sets

if [[ -z $TZ ]]; then
	(cd /mnt/usr/share/zoneinfo
	    ls -1dF `tar cvf /dev/null [A-Za-y]*` >/mnt/tmp/tzlist )
	echo
	set_timezone /mnt/tmp/tzlist
	rm -f /mnt/tmp/tzlist
fi

if _time=$(ftp_time) && _now=$(date +%s) && \
	(( _now - _time > 120 || _time - _now > 120 )); then
	_tz=/mnt/usr/share/zoneinfo/$TZ
	ask_yn "Time appears wrong.  Set to '$(TZ=$_tz date -r "$(ftp_time)")'?" yes
	if [[ $resp == y ]]; then
		date $(date -r "$(ftp_time)" "+%Y%m%d%H%M.%S") >/dev/null
	fi
fi

if [[ -s $SERVERLISTALL ]]; then
	_i=
	[[ -n $installedfrom ]] && _i="install=$installedfrom"
	[[ -n $TZ ]] && _i="$_i&TZ=$TZ"
	[[ -n $method ]] && _i="$_i&method=$method"

	[[ -n $_i ]] && ftp $FTPOPTS -a -o - \
		"http://129.128.5.191/cgi-bin/ftpinstall.cgi?$_i" >/dev/null 2>&1 &
fi

sed -e "/^console.*on.*secure.*$/s/std\.[0-9]*/std.$(stty speed)/" \
	/mnt/etc/ttys >/tmp/ttys
mv /tmp/ttys /mnt/etc/ttys

echo -n "Saving configuration files..."

(cd /var/db; [ -f dhclient.leases ] && mv dhclient.leases /mnt/var/db/. )

hostname >/tmp/myname

if [[ -f /tmp/hosts ]]; then
	_dn=$(get_fqdn)
	while read _addr _hn _aliases; do
		if [[ -n $_aliases || $_hn != ${_hn%%.*} || -z $_dn ]]; then
			echo "$_addr	$_hn $_aliases"
		else
			echo "$_addr	$_hn.$_dn $_hn"
		fi
	done </tmp/hosts >>/mnt/etc/hosts
	rm /tmp/hosts
fi

_f=dhclient.conf
[[ -f /tmp/$_f ]] && { cat /tmp/$_f >>/mnt/etc/$_f ; rm /tmp/$_f ; }

(cd /tmp; for _f in fstab hostname* kbdtype my* ttys *.conf *.tail; do
	[[ -f $_f && -s $_f ]] && mv $_f /mnt/etc/.
done)

(dmesg; cat $SERVERLISTALL; sysctl; route -n show; df;
    ifconfig -A; hostname) >/mnt/dev/arandom 2>&1

echo -n "done.\nGenerating initial host.random file..."
/mnt/bin/dd if=/mnt/dev/arandom of=/mnt/var/db/host.random \
	bs=65536 count=1 >/dev/null 2>&1
chmod 600 /mnt/var/db/host.random >/dev/null 2>&1
echo "done."

apply

if [[ -n $user ]]; then
	_encr="*"
	[[ -n "$userpass" ]] && _encr=`/mnt/usr/bin/encrypt -b 8 -- "$userpass"`
	uline="${user}:${_encr}:1000:1000:staff:0:0:${username}:/home/${user}:/bin/ksh"
	echo "$uline" >> /mnt/etc/master.passwd
	echo "${user}:*:1000:" >> /mnt/etc/group
	echo ${user} > /mnt/root/.forward

	mkdir -p /mnt/home/$user
	(cd /mnt/etc/skel; cp -pR . /mnt/home/$user)
	(umask 077 &&
		sed "s,^To: root\$,To: ${username} <${user}>," \
		/mnt/var/mail/root > /mnt/var/mail/$user )
	chown -R 1000:1000 /mnt/home/$user /mnt/var/mail/$user
	echo "1,s@wheel:.:0:root\$@wheel:\*:0:root,${user}@
w
q" | /mnt/bin/ed /mnt/etc/group 2>/dev/null
fi

if [[ -n "$_rootpass" ]]; then
	_encr=`/mnt/usr/bin/encrypt -b 8 -- "$_rootpass"`
	echo "1,s@^root::@root:${_encr}:@
w
q" | /mnt/bin/ed /mnt/etc/master.passwd 2>/dev/null
fi
/mnt/usr/sbin/pwd_mkdb -p -d /mnt/etc /etc/master.passwd

if grep -qs '^rtsol' /mnt/etc/hostname.*; then
       sed -e "/^#\(net\.inet6\.ip6\.accept_rtadv\)/s//\1/" \
       	   -e "/^#\(net\.inet6\.icmp6\.rediraccept\)/s//\1/" \
               /mnt/etc/sysctl.conf >/tmp/sysctl.conf
       cp /tmp/sysctl.conf /mnt/etc/sysctl.conf
fi

finish_up
