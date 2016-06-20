. ./ver.sh

cmd="doas cdrecord -overburn -data speed=24 dev=/dev/cd0c AprendiendoDeJesus-$V$VESP-$ARQ.iso"
echo $cmd
eval $cmd
