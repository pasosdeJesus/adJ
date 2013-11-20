#!/bin/sh

. ./ver.sh

cmd="rsync --delete -e \"ssh $OPSSHOTRO\" -ravz $USOTRO@$OTRO:$DIROTRO/adJ/$V$VESP-$ARQ/paquetes/* $V$VESP-$ARQ/paquetes/"
echo $cmd
eval $cmd

