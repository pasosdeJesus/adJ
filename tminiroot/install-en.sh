#!/bin/ksh
#      $OpenBSD: install.sh,v 1.259 2015/01/02 22:38:50 rpe Exp $
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
_fsent=

rm -f /tmp/fstab*

ask_yn "Use DUIDs rather than device names in fstab?" yes && FSTABFLAG=-F

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
	md_prep_disklabel $DISK || { DISK=; continue ; }

	grep -qs " / ffs " /tmp/fstab.$ROOTDISK ||
		{ DISK=; echo "'/' must be configured!"; continue ; }

	if [[ -f /tmp/fstab.$DISK ]]; then
		while read _pp _mp _rest; do
			if [[ $_mp == none ]]; then
				echo "$_pp $_mp $_rest" >>/tmp/fstab
				continue
			fi
			[[ /tmp/fstab.$DISK == $(grep -l " $_mp " /tmp/fstab.*) ]] ||
				{ _rest=$DISK; DISK=; break; }
		done </tmp/fstab.$DISK
		if [[ -z $DISK ]]; then
			cat /tmp/fstab.$_rest >/etc/fstab
			rm /tmp/fstab.$_rest
			set -- $(grep -h " $_mp " /tmp/fstab.*[0-9])
			echo "$_pp and $1 can't both be mounted at $_mp."
			continue
		fi

		while read _pp _mp _fstype _rest; do
			[[ $_fstype == ffs ]] || continue
			_OPT=
			[[ $_mp == / ]] && _OPT=$MDROOTFSOPT
			newfs -q $_OPT ${_pp##/dev/}
			_fsent="$_fsent $_mp!$_pp"
		done </tmp/fstab.$DISK
	fi
done

for _mp in $(bsort $_fsent); do
	_pp=${_mp##*!}
	_mp=${_mp%!*}
	echo -n "$_pp $_mp ffs rw"

	[[ $_mp == / ]] && { echo " 1 1"; continue; }

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

feed_random

install_sets

if [[ -z $TZ ]]; then
	(cd /mnt/usr/share/zoneinfo
		ls -1dF $(tar cvf /dev/null [A-Za-y]*) >/mnt/tmp/tzlist )
	echo
	set_timezone /mnt/tmp/tzlist
	rm -f /mnt/tmp/tzlist
fi

if _time=$(http_time) && _now=$(date +%s) &&
	(( _now - _time > 120 || _time - _now > 120 )); then
	_tz=/mnt/usr/share/zoneinfo/$TZ
	if ask_yn "Time appears wrong.  Set to '$(TZ=$_tz date -r "$(http_time)")'?" yes; then
		date $(date -r "$(http_time)" "+%Y%m%d%H%M.%S") >/dev/null
	fi
fi

if [[ -s $HTTP_LIST ]]; then
	_i=
	[[ -n $INSTALL ]] && _i="install=$INSTALL"
	[[ -n $TZ ]] && _i="$_i&TZ=$TZ"
	[[ -n $METHOD ]] && _i="$_i&method=$METHOD"

	[[ -n $_i ]] && ftp -Vao - \
		"http://129.128.5.191/cgi-bin/ftpinstall.cgi?$_i" >/dev/null 2>&1 &
fi

sed "/^console.*on.*secure.*$/s/std\.[0-9]*/std.$(stty speed </dev/console)/" \
	/mnt/etc/ttys >/tmp/ttys
mv /tmp/ttys /mnt/etc/ttys

echo -n "Saving configuration files..."

(cd /var/db; for _f in dhclient.leases.*; do
	[[ -f $_f ]] && mv $_f /mnt/var/db/.
done)

hostname >/tmp/myname
echo "127.0.0.1	localhost" >/mnt/etc/hosts
echo "::1		localhost" >>/mnt/etc/hosts
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
[[ -f /tmp/$_f ]] && { cat /tmp/$_f >>/mnt/etc/$_f; rm /tmp/$_f; }

(cd /tmp; for _f in fstab hostname* kbdtype my* ttys *.conf *.tail; do
	[[ -f $_f && -s $_f ]] && mv $_f /mnt/etc/.
done)

echo "done."
apply

if [[ -n $user ]]; then
	_encr=$(encr_pwd "$userpass")
	_home=/home/$user
	uline="${user}:${_encr}:1000:1000:staff:0:0:${username}:$_home:/bin/ksh"
	echo "$uline" >> /mnt/etc/master.passwd
	echo "${user}:*:1000:" >> /mnt/etc/group
	echo ${user} > /mnt/root/.forward

	_home=/mnt$_home
	mkdir -p $_home
	(cd /mnt/etc/skel; cp -pR . $_home)
	(umask 077 &&
		sed "s,^To: root\$,To: ${username} <${user}>," \
		/mnt/var/mail/root > /mnt/var/mail/$user )
	chown -R 1000:1000 $_home /mnt/var/mail/$user
	echo "1,s@wheel:.:0:root\$@wheel:\*:0:root,${user}@
w
q" | ed /mnt/etc/group 2>/dev/null

	[[ -n "$userkey" ]] &&
		print -r -- "$userkey" >> $_home/.ssh/authorized_keys
fi

if [[ -n "$_rootpass" ]]; then
	_encr=$(encr_pwd "$_rootpass")
	echo "1,s@^root::@root:${_encr}:@
w
q" | ed /mnt/etc/master.passwd 2>/dev/null
fi
/mnt/usr/sbin/pwd_mkdb -p -d /mnt/etc /etc/master.passwd

[[ -n "$rootkey" ]] && (
	umask 077
	mkdir /mnt/root/.ssh
	print -r -- "$rootkey" >> /mnt/root/.ssh/authorized_keys
)

finish_up
