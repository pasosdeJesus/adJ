#!/bin/ksh
#      $OpenBSD: install.sh,v 1.275 2016/02/11 14:24:28 rpe Exp $
#	$NetBSD: install.sh,v 1.5.2.8 1996/08/27 18:15:05 gwr Exp $
#
# Copyright (c) 1997-2015 Todd Miller, Theo de Raadt, Ken Westerback
# Copyright (c) 2015, Robert Peichaer <rpe@openbsd.org>
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

# Ask for/set the system hostname and add the hostname specific siteXX set.
ask_until "System hostname? (short form, e.g. 'foo')" "$(hostname -s)"
[[ ${resp%%.*} != $(hostname -s) ]] && hostname "$resp"
THESETS="$THESETS site$VERSION-$(hostname -s).tgz"

echo

# Configure the network.
donetconfig

# If there's network connectivity, fetch list of mirror servers and installer
# choices from previous runs.
((NIFS)) && startcgiinfo

echo

while :; do
	askpassword "Password for root account?"
	_rootpass="$_password"
	[[ -n "$_password" ]] && break
	echo "The root password must be set."
done

# Ask for the root user public ssh key during autoinstall.
rootkey=
if $AUTO; then
	ask "Public ssh key for root account?" none
	[[ $resp != none ]] && rootkey=$resp
fi

# Ask user about daemon startup on boot, X Window usage and console setup.
questions

# Gather information for setting up the initial user account.
user_setup
ask_root_sshd

# Set TZ variable based on zonefile and user selection.
set_timezone /var/tzlist

echo
# Get information about ROOTDISK, etc.
get_rootinfo

DISKS_DONE=
FSENT=

rm -f /tmp/fstab*

# Configure the disk(s).
while :; do
	if ! isin $ROOTDISK $DISKS_DONE; then
		resp=$ROOTDISK
		rm -f /tmp/fstab
	else
		ask_which "$_sldisk" "$_slinit" \
			'$(get_dkdevs_uninitialized)' $_sldone
		[[ $resp == $_sldone ]] && break
	fi
	_disk=$resp
	configure_disk $_disk || continue
	DISKS_DONE=$(addel $_disk $DISKS_DONE)
done

for _mp in $(bsort $FSENT); do
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
	if ask_yn "$_sltimeappears '$(TZ=$_tz date -r "$(http_time)")'?" $_slyes; then
		date $(date -r "$(http_time)" "+%Y%m%d%H%M.%S") >/dev/null
	fi
fi

if [[ -s $HTTP_LIST ]]; then
	_i=${INSTALL:+install=$INSTALL&}
	_i=$_i${TZ:+TZ=$TZ&}
	_i=$_i${METHOD:+method=$METHOD}
	_i=${_i%&}
	[[ -n $_i ]] && ftp -Vao - \
		"http://129.128.5.191/cgi-bin/ftpinstall.cgi?$_i" >/dev/null 2>&1 &
fi

sed "/^console.*on.*secure.*$/s/std\.[0-9]*/std.$(stty speed </dev/console)/" \
	/mnt/etc/ttys >/tmp/ttys
mv /tmp/ttys /mnt/etc/ttys

echo -n "$_slsaving"

(cd /var/db; for _f in dhclient.leases.*; do
	[[ -f $_f ]] && mv $_f /mnt/var/db/.
done)

hostname >/tmp/myname
echo "127.0.0.1\\tlocalhost" >/mnt/etc/hosts
echo "::1\\t\\tlocalhost" >>/mnt/etc/hosts
if [[ -f /tmp/hosts ]]; then
	_dn=$(get_fqdn)
	while read _addr _hn _aliases; do
		if [[ -n $_aliases || $_hn != ${_hn%%.*} || -z $_dn ]]; then
			echo "$_addr\\t$_hn $_aliases"
		else
			echo "$_addr\\t$_hn.$_dn $_hn"
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
	echo "$uline" >>/mnt/etc/master.passwd
	echo "${user}:*:1000:" >>/mnt/etc/group
	echo ${user} >/mnt/root/.forward

	_home=/mnt$_home
	mkdir -p $_home
	(cd /mnt/etc/skel; cp -pR . $_home)
	(umask 077 && sed "s,^To: root\$,To: ${username} <${user}>," \
		/mnt/var/mail/root >/mnt/var/mail/$user )
	chown -R 1000:1000 $_home /mnt/var/mail/$user
	sed -i -e "s@^wheel:.:0:root\$@wheel:\*:0:root,${user}@" \
		/mnt/etc/group 2>/dev/null
	[[ -n "$userkey" ]] &&
		print -r -- "$userkey" >>$_home/.ssh/authorized_keys
fi

if [[ -n "$_rootpass" ]]; then
	_encr=$(encr_pwd "$_rootpass")
	sed -i -e "s@^root::@root:${_encr}:@" /mnt/etc/master.passwd 2>/dev/null
fi
pwd_mkdb -p -d /mnt/etc /etc/master.passwd

[[ -n "$rootkey" ]] && (
	umask 077
	mkdir /mnt/root/.ssh
	print -r -- "$rootkey" >>/mnt/root/.ssh/authorized_keys
)

finish_up
