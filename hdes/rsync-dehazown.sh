#!/bin/sh

. ./ver.sh

cmd="rsync --delete -e \"ssh $OPSSHHAZOWN\" -ravz vtamara@$HAZOWN:comp/adJ/$V$VESP-$ARQ/* $V$VESP-$ARQ"
echo $cmd
eval $cmd

