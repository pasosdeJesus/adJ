#!/bin/sh

. ./ver.sh

rsync --delete -e "ssh $OPSSHHAZOWN" -ravz $V$VESP-$ARQ/* vtamara@$HAZOWN:comp/adJ/$V$VESP-$ARQ/
