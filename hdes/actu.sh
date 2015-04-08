. ./ver.sh

mkdir -p $V$VESP-$ARQ/
rsync -ravz -e "ssh -p11022" vtamara@adJ.pasosdeJesus.org:/home/ftp/pub/AprendiendoDeJesus/$V$VESP-$ARQ/ $V$VESP-$ARQ
