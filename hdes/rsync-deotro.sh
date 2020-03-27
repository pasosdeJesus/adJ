#!/bin/sh

. ./ver.sh

cmd="rsync --delete -e \"ssh $OPSSHOTRO\" -raPvcz $USOTRO@$OTRO:$DIROTRO/adJ/$V$VESP-$ARQ/ $V$VESP-$ARQ/"
echo $cmd
eval $cmd

