#!/bin/sh
# Prueba el arranque de la imagen .img en modo UEFI con QEMU.
# Dominio público. 2026. vtamara@pasosdeJesus.org
#
# Usa el firmware EDK2 que trae el paquete qemu (no hay un paquete edk2-ovmf
# aparte) y crea un archivo de variables NVRAM temporal, porque el paquete
# qemu de OpenBSD no incluye edk2-x86_64-vars.fd. Arranca con snapshot para
# no modificar la .img.

. ./ver.sh

img="AprendiendoDeJesus-${V}${VESP}-${ARQ}.img"
fwcode="/usr/local/share/qemu/edk2-x86_64-code.fd"
vars="/tmp/edk2-x86_64-vars-$$.fd"

if (test ! -f "$img") then {
  echo "No existe $img. Ejecuta desde la raíz del repositorio adJ." >&2
  exit 1
} fi;

if (test ! -f "$fwcode") then {
  echo "No existe el firmware UEFI $fwcode (instala el paquete qemu)." >&2
  exit 1
} fi;

# NVRAM temporal (540 KiB, tamaño que se verificó que arranca).
dd if=/dev/zero of="$vars" bs=1024 count=540 >/dev/null 2>&1

trap 'rm -f "$vars"' EXIT

echo "Arrancando $img en modo UEFI (snapshot, no modifica la imagen)..."
echo "Para salir: [Ctrl-a] x"

qemu-system-x86_64 -m 384M \
  -drive if=pflash,format=raw,readonly=on,file="$fwcode" \
  -drive if=pflash,format=raw,file="$vars" \
  -drive file="$img",format=raw,snapshot=on \
  -nographic
