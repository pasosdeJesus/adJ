#!/bin/sh

. ./ver.sh

cmd="rsync --delete -e \"ssh $OPSSHOTRO\" -ravz $USOTRO@$OTRO:comp/adJ/$V$VESP-$ARQ/* $V$VESP-$ARQ"
echo $cmd
eval $cmd

