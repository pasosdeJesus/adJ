#!/bin/sh
# Variables de configuración para generar distribución Aprendiendo de Jesús
# Dominio público. 2020. vtamara@pasosdeJesus.org

V=6.9
VESP=""
# Versión que se está desarrollando

VPKGPATH=$V
VP=`echo $V | sed -e "s/[.]//g"`
VP=69
VU=`echo $V | sed -e "s/[.]/_/g"`
VNUM=`echo $V | sed -e "s/\.//g"`
VNUMS=`expr $VNUM + 1`
VS=`echo $VNUMS | sed -e "s/\([0-9]\)\([0-9]\)/\1.\2/g"`
# Versión siguiente

ARQ=amd64
#`uname -m`
# Arquitectura

export R="OPENBSD_$VU"
export RADJ="ADJ_$VU"
# Ramas

PKG_PATH=http://ftp.openbsd.org/pub/OpenBSD/$VPKGPATH/packages/$ARQ/
PKG_PATH=http://ftp3.usa.openbsd.org/pub/OpenBSD/$VPKGPATH/packages/$ARQ/
PKG_PATH=http://openbsd.mirrors.pair.com/pub/OpenBSD/$VPKGPATH/packages/$ARQ/
PKG_PATH=http://mirror.esc7.net/pub/OpenBSD/$VPKGPATH/packages/$ARQ/
PKG_PATH=http://ftp4.usa.openbsd.org/pub/OpenBSD/$VPKGPATH/packages/$ARQ/
PKG_PATH=http://cdn.openbsd.org/pub/OpenBSD/$VPKGPATH/packages/$ARQ/
PKG_PATH=http://adJ.pasosdeJesus.org/pub/OpenBSD/$VPKGPATH/packages/$ARQ/

#Repositorio de paquetes usado --el último es el usado

METODOACT=ftp
# Metodo de actualización, puede ser ftp o rsync

excluye="chromium-.*-proprietary.* gnupg-2.* libstdc++-.* python-.* python-tkinter-.* php-.* pear-Auth-.* pear-DB_DataObject.* pear-HTML-QuickForm-Controller.* pear-Validate-.* postgresql-.* ruby-1.* ruby-2.0.* tcl-.* tk-.* xfe-.*"
# Paquetes por excluir de descarga ftp de OpenBSD

RUTAKERNELREESPECIAL=""
# Si debe usarse un kernel por ejemplo sin rlphy

# Datos del CVS del cual se actualizan fuentes de OpenBSD
USUARIOCVS="anoncvs"
MAQCVS="anoncvs4.usa.openbsd.org"
DIRCVS="/cvs"

export DESTDIR=/build/destdir; 
export RELEASEDIR=/releasedir
export XSRCDIR=/usr/xenocara;
# Directorios para compilación 

# Estas variables controlan operacion de distribucion.sh pueden ser s o n
export autoCvs=n
# Actualizar fuentes y portes del CVS de OpenBSD 
export autoCompKernel=n
# Transformar y compilar kernel 
export autoInsKernel=n
# Instalar kernel compilado
export autoActZonasHorarias=n
# Actualizar zonas horarias
export autoCompBase=n
# Transformar y compilar sistema base
export autoElimCompBase=n
# Elimina Compila Base
export autoDist=n
# Crear distribución en /releasedir y /destdir
export autoBsdrd=n
# Crear bsd.rd
export autoElimDist=n
# Eliminar distribución de /destdir y /releasedir
export autoX=n
# Transformar y compilar Xenocara
export autoXDist=n
# Distribución de Xenocara en /destdir y /releasedir
export autoElimX=n
# Elimina objeto tras autoX
export autoElimXDist=n
# Elimina distribución de Xenocara
export autoJuegosInstalacion=n
# Crear juegos de instalación en subdirectorio de este
export autoTodosPaquetes=n
# Compilar todos los paquetes (util en Octubre y Abril)
export autoPaquetes=n
# Compilar paquetes especiales que hacen parte de la distribución

export autoMasPaquetes=s
# Descargar resto de paquetes de repositorio PKG_PATH
export autoMasPaquetesInv=n
# Descargar en orden inverso
export autoSite=s
# Generar siteXX.tgz
export autoTextos=s
# Copiar/generar textos Novedades.md y demás


qemuboot=c
# Unidad por la cual arrancar por defecto con hdes/qemu.sh

if (test -f "ver-local.sh") then {
	. ./ver-local.sh
} fi;
