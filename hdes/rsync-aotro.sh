#!/bin/sh

. ./ver.sh

cmd="rsync -vrt --size-only --delete -e \"ssh $OPSSHOTRO\" $V$VESP-$ARQ/ $USOTRO@$OTRO:$DIROTRO/adJ/$V$VESP-$ARQ"
echo $cmd
eval $cmd

cmd="rsync --delete -e \"ssh $OPSSHOTRO\" $V$VESP-$ARQ/ -ravz $USOTRO@$OTRO:$DIROTRO/adJ/$V$VESP-$ARQ"
echo $cmd
eval $cmd

