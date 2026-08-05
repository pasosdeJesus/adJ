#!/bin/sh

copy_deps() {
    local binary="$1"
    local chroot_dir="$2"
    local dest_dir
    local lib_dir="${chroot_dir}/usr/lib"
    mkdir -p "$lib_dir"

    # Copiar el binario con su ruta completa
    dest_dir="${chroot_dir}$(dirname "$binary")"
    doas mkdir -p "$dest_dir"
    doas cp "$binary" "$dest_dir/"

    # Extraer rutas de bibliotecas con ldd y awk
    ldd "$binary" | awk '{
        for(i=1; i<=NF; i++) {
            if($i ~ /^\//) {
                gsub(/\(.*\)/, "", $i)
                print $i
                break
            }
        }
    }' | while read lib; do
        if [ -f "$lib" ] && [ ! -f "${chroot_dir}${lib}" ]; then
            echo "Copiando $lib"
            doas cp "$lib" "$lib_dir/"
        fi
    done
}   

# Parte del sistema base 
doas mkdir -p /var/jaula-ia/{bin,dev,etc,lib,root,sbin,usr/bin,usr/lib,usr/libexec,usr/local/bin,usr/local/lib,usr/local/libexec,usr/local/share,usr/sbin,usr/share/terminfo/,var/run}
doas cp /bin/* /var/jaula-ia/bin/
doas cp /usr/sbin/* /var/jaula-ia/usr/sbin/
doas cp /sbin/mknod /var/jaula-ia/sbin/
doas cp -rf /usr/share/terminfo/* /var/jaula-ia/usr/share/terminfo/
cd /var/jaula-ia/dev
doas ./MAKEDEV std

# Enlazador dinamico
doas cp /sbin/ldconfig /var/jaula-ia/sbin/
doas cp /usr/libexec/ld.so /var/jaula-ia/usr/libexec/
doas sh -c 'echo "/usr/lib" > /var/jaula-ia/etc/ld.so.conf'
doas sh -c 'echo "/usr/local/lib" >> /var/jaula-ia/etc/ld.so.conf'
doas chroot /var/jaula-ia /sbin/ldconfig

# Resolvedor
doas cp /etc/resolv.conf /var/jaula-ia/etc/
doas cp -rf /etc/ssl/ /var/jaula-ia/etc/

# Paquetes
#
# node
doas cp -r /usr/local/bin/node /var/jaula-ia/usr/local/bin/
doas cp -r /usr/local/lib/node_modules /var/jaula-ia/usr/local/lib/
copy_deps /usr/local/bin/node /var/jaula-ia/
copy_deps /usr/bin/env /var/jaula-ia/
copy_deps /usr/bin/less /var/jaula-ia/
doas cp /usr/local/bin/npm /var/jaula-ia/usr/local/bin/

# git
copy_deps /usr/local/bin/git /var/jaula-ia/
copy_deps /usr/local/libexec/git/git-remote-https /var/jaula-ia/
doas cp -rf /usr/local/share/git-core /var/jaula-ia//usr/local/share/
doas cp -rf /usr/local/libexec/git /var/jaula-ia//usr/local/libexec/



rm /var/jaula-ia/dev/sd*
rm /var/jaula-ia/dev/rsd*

