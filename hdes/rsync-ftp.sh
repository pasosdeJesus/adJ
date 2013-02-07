#!/bin/sh

. ./ver.sh

cmd="sudo rsync --delete -ravz rsync://$RSYNCHOST/OpenBSD/$V/amd64/install*iso ftp-$V-$ARQ/"
echo $cmd;
eval $cmd;
cmd="sudo rsync --delete -ravz rsync://$RSYNCHOST/OpenBSD/$V/packages/amd64/* ftp-$V-$ARQ/"
echo $cmd;
eval $cmd;
