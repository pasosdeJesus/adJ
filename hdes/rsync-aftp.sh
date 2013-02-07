#!/bin/sh

. ./ver.sh

rsync --port=11022 --delete -ravz $V$VESP-$ARQ/* vtamara@ftp.pasosdeJesus.org:comp/adJ/$V$VESP-$ARQ/
