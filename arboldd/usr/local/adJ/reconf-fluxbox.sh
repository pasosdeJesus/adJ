#!/bin/sh
# Configura fluxbox en cuenta del usuario $uadJ o del que ejecuta
# Copia fondos de pantalla desde $ARCH/

if (test "$uadJ" = "") then {
  uadJ=$USER
} fi;

if (test ! -f /home/$uadJ/.xsession) then {
  cat > /home/$uadJ/.xsession <<EOF
    /usr/local/bin/startfluxbox
EOF
  chown $uadJ:$uadJ /home/$uadJ/.xsession > /dev/null 2>&1
} fi;

if (test -f /home/$uadJ/.fluxbox/menu) then {
	rm -f /home/$uadJ/.fluxbox/menu
	rm -f /home/$uadJ/.fluxbox/startup
	rm -f /home/$uadJ/.fluxbox/init
} fi;

mkdir -p /home/$uadJ/.fluxbox
cat > /home/$uadJ/.fluxbox/menu <<EOF

[begin] (Fluxbox)
	[exec] (xfe - Archivos) {PATH=\$PATH:/usr/sbin:/usr/local/sbin:/sbin /usr/local/bin/xfe}
	[exec] (xterm+tmux) { xterm -geometry 160x48 -en utf8 -e "TERM=xterm-color /usr/bin/tmux -2 -l" }
	[exec] (xterm) { xterm -geometry 160x48 -en utf8 -ls }
	[exec] (chromium) {/usr/local/bin/chrome --disable-gpu --allow-file-access-from-files}
	[exec] (firefox-esr) {/usr/local/bin/firefox-esr}
[submenu] (Espiritualidad)
	[exec] (bibletime) {/usr/local/bin/bibletime}
	[exec] (Evangelios de dominio publico) {/usr/local/bin/chrome --disable-gpu /usr/local/share/doc/evangelios_dp/}
[end]
[submenu] (Dispositivos)
	[exec] (Apagar) {doas /sbin/halt -p}
	[exec] (Iniciar servicios faltantes) {xterm -en utf8 -e "/usr/bin/doas /bin/ksh /etc/rc.local espera"}
	[exec] (Montar CD) {doas /sbin/mount /mnt/cdrom ; xhost +; doas xfe /mnt/cdrom/ }
	[exec] (Desmontar CD) {doas /sbin/umount -f /mnt/cdrom}
	[exec] (Montar USB) {doas /sbin/mount /mnt/usb ; xhost +; doas xfe /mnt/usb/}
	[exec] (Desmontar USB) {doas /sbin/umount -f /mnt/usb}
	[exec] (Montar USBC) {doas /sbin/mount /mnt/usbc ; xhost +; doas xfe /mnt/usbc/}
	[exec] (Desmontar USBC) {doas /sbin/umount -f /mnt/usbc}
	[exec] (Montar Floppy) {doas /sbin/mount /mnt/floppy ; xhost +; doas xfe /mnt/floppy}
	[exec] (Desmontar Floppy) {doas /sbin/umount -f /mnt/floppy}
	[exec] (Configurar Impresora con CUPS) {echo y | doas cups-enable; doas chmod a+rw /dev/ulpt* /dev/lpt*; /usr/local/bin/chrome --disable-gpu http://127.0.0.1:631}
	[submenu] (Teclado)
                [exec] (Cambiar a distribucion Lationoamerica) {setxkbmap latam}
                [exec] (Cambiar a distribucion Estados Unidos) {setxkbmap us}
  [end]
	[submenu] (Red)
                [exec] (Examinar red) {xterm -en utf8 -e '/sbin/ifconfig; echo -n "\n[RETORNO] para examinar enrutamiento (podrá salir con q)"; read; /sbin/route -n show | less'}
                [exec] (Examinar configuracion cortafuegos) {xterm  -en utf8 -e 'doas  /sbin/pfctl -s all | less '}
                [exec] (Configurar interfaces de red) {xterm -en utf8 -e '/sbin/ifconfig | grep "^[a-z]*[0-9]:" | sed -e "s/:.*//g" | grep -v "lo0" | grep -v "enc0" | grep -v "pflog0" | grep -v "tun[0-9]" | sed -e "s/\(.*\)/echo \"ENTER para configurar \1\";read;xfw \/etc\/hostname.\1/g" > /tmp/porc.sh;  xhost +; doas sh /tmp/porc.sh' }
                [exec] (Configurar puerta de enlace) {doas touch /etc/mygate; xhost +; doas xfw /etc/mygate}
                [exec] (Configurar cortafuegos) {xhost +; doas xfw /etc/pf.conf}
                [exec] (Reiniciar red) {xterm -en utf8 -e 'PATH=/sbin:/usr/sbin:/bin:/usr/bin/ /usr/bin/doas /bin/sh /etc/netstart && /usr/bin/doas /sbin/pfctl -f /etc/pf.conf; echo "[RETORNO] para continuar"; read'}
                [exec] (ping a Internet) {xterm -en utf8 -e '/sbin/ping 190.71.138.118'}
        [end]
[end]
[submenu] (Oficina)
	[exec] (evince) {evince}
	[exec] (gnumeric) {LC_CTYPE=C /usr/local/bin/gnumeric}
	[exec] (gv) {gv}
	[exec] (gimp) {LC_CTYPE=C /usr/local/bin/gimp-2.99}
	[exec] (inkscape) {inkscape}
	[exec] (LibreOffice) {/usr/local/bin/soffice}
[end]
[submenu] (Multimedia)
	[exec] (audacious) {audacious}
	[exec] (audacity) {audacity}
	[exec] (cdio cdplay) {xterm -en utf8 -e "cdio cdplay"}
	[exec] (musescore) {musescore}
	[exec] (xcdplayer) {xcdplayer}
	[exec] (vlc) {vlc}
[end]
[submenu] (Internet)
	[exec] (FileZilla) {filezilla}
[end]
[submenu] (Documentos)
	[exec] (adJ basico) {/usr/local/bin/chrome --disable-gpu /usr/local/share/doc/basico_adJ/index.html}
	[exec] (adJ usuario) {/usr/local/bin/chrome --disable-gpu /usr/local/share/doc/usuario_adJ/index.html}
	[exec] (adJ servidor) {/usr/local/bin/chrome --disable-gpu /usr/local/share/doc/servidor_adJ/index.html}
[end]
[submenu] (Otros)
[exec] (gvim) {gvim}
[exec] (qemu) {qemu-system-x86_64}
[exec] (xarchiver) {xarchiver}
[exec] (xfw) {xfw}
[end]
[submenu] (Menu de fluxbox)
[config] (Configurar)
[submenu] (Estilos del sistema) {Elija un estilo ...}
[stylesdir] (/usr/local/share/fluxbox/styles)
[end]
[submenu] (Estilos de usuario) {Elija un estilo...}
[stylesdir] (~/.fluxbox/styles)
[end]
[workspaces] (Lista de espacios de trabajo)
[submenu] (Herramientas)
[exec] (Nombre de ventana) {xprop WM_CLASS|cut -d " -f 2|xmessage -file - -center}
[exec] (Foto de la pantalla - JPG) {import screenshot.jpg && display -resize 50% screenshot.jpg}
[exec] (Foto de la pantalla - PNG) {import screenshot.png && display -resize 50% screenshot.png}
[end]
[submenu] (Administrador de Ventanas)
[restart] (cwm) {cwm}
[restart] (fvwm) {fvwm}
[restart] (twm) {twm}
[restart] (mwm) {mwm}
[end]
[exec] (Bloquear pantalla) {xlock}
[commanddialog] (Comando de Fluxbox)
[reconfig] (Cargar nuevamente la configuracion)
[restart] (Volver a iniciar)
[exec] (Acerca de) {(fluxbox -v; fluxbox -info | sed 1d) 2> /dev/null | xmessage -file - -center}
[separator]
[exit] (Exit)
[end]
[exec] (Reiniciar) {doas /sbin/reboot}
[exec] (Apagar) {doas /sbin/halt -p}
[end]
EOF

if (test ! -f /home/$uadJ/.fluxbox/startup -a "$ARCH" != "" -a -d "$ARCH") then {
	mkdir -p /home/$uadJ/.fluxbox/backgrounds/
	imfondo=`ls -lat $ARCH/medios/*.jpg | head -n 1 | sed -e "s/.*medios\///g"`
	echo "Imagen de fondo: $imfondo" 
	cp $ARCH/medios/*.jpg /home/$uadJ/.fluxbox/backgrounds/
	cp $ARCH/medios/$imfondo /home/$uadJ/.fluxbox/backgrounds/fondo.jpg
	cat > /home/$uadJ/.fluxbox/startup <<EOF
#fbsetroot -to blue -solid lightblue
export LANG=es_CO.UTF-8
if (test -x /usr/local/bin/fluxter) then {
	/usr/local/bin/fluxter &
} fi;
im=fondo.jpg
if (test -x /usr/local/bin/fbsetbg -a -x /usr/local/bin/display -a -f /home/$uadJ/.fluxbox/backgrounds/\$im) then {
	display -backdrop -window root /home/$uadJ/.fluxbox/backgrounds/\$im
} fi;
if (test -x /usr/local/bin/pidgin) then {
	LANG=es_CO.UTF-8 /usr/local/bin/pidgin &
} fi;
xterm -geometry 160x48 -en utf8 -e /usr/bin/tmux -l &
# /usr/local/bin/bsetroot -solid black
# fbsetbg -C /usr/local/share/fluxbox/splash.jpg
# xset -b
# xset r rate 195 35
# xset +fp /home/$uadJ/.font
# xsetroot -cursor_name right_ptr
# xmodmap ~/.Xmodmap
# unclutter -idle 2 &
# wmnd &
# wmsmixer -w &
# idesk &
if (test -x /usr/X11R6/bin/xcompmgr) then {
#        /usr/X11R6/bin/xcompmgr -CcfF -I-.015 -O-.03 -D2 -t-1 -l-3 -r4.2 -o.5 &
} fi;

exec /usr/local/bin/fluxbox -log ~/.fluxbox/log
EOF
  grep -v "display -backdrop -window .*\$im"  /home/$uadJ/.fluxbox/apps > /tmp/a 2>/dev/null
  cat /tmp/a - > /home/$uadJ/.fluxbox/apps <<EOF
	[startup] {display -backdrop -window root /home/$uadJ/.fluxbox/backgrounds/fondo.jpg}
EOF
} fi;

if (test ! -f /home/$uadJ/.fluxbox/init) then {
	mkdir -p /home/$uadJ/.fluxbox/
	cat > /home/$uadJ/.fluxbox/init <<EOF
session.screen0.overlay.lineWidth:	1
session.screen0.overlay.lineStyle:	LineSolid
session.screen0.overlay.joinStyle:	JoinMiter
session.screen0.overlay.capStyle:	CapNotLast
session.screen0.tab.alignment:	Left
session.screen0.tab.width:	64
session.screen0.tab.rotatevertical:	True
session.screen0.tab.height:	16
session.screen0.tab.placement:	Top
session.screen0.titlebar.left:	Stick 
session.screen0.titlebar.right:	Minimize Maximize Close 
session.screen0.toolbar.layer:	Desktop
session.screen0.toolbar.widthPercent:	66
session.screen0.toolbar.onhead:	0
session.screen0.toolbar.height:	0
session.screen0.toolbar.alpha:	250
session.screen0.toolbar.onTop:	False
session.screen0.toolbar.autoHide:	false
session.screen0.toolbar.tools:	workspacename, prevworkspace, nextworkspace, iconbar, systemtray, prevwindow, nextwindow, clock
session.screen0.toolbar.visible:	true
session.screen0.toolbar.maxOver:	false
session.screen0.toolbar.placement:	BottomCenter
session.screen0.menu.alpha:	255
session.screen0.iconbar.mode:	Workspace
session.screen0.iconbar.alignment:	Relative
session.screen0.iconbar.deiconifyMode:	Follow
session.screen0.iconbar.usePixmap:	true
session.screen0.iconbar.wheelMode:	Screen
session.screen0.iconbar.iconTextPadding:	10l
session.screen0.iconbar.iconWidth:	70
session.screen0.slit.onTop:	False
session.screen0.slit.onhead:	0
session.screen0.slit.autoHide:	false
session.screen0.slit.layer:	Dock
session.screen0.slit.maxOver:	false
session.screen0.slit.direction:	Vertical
session.screen0.slit.alpha:	255
session.screen0.slit.placement:	BottomRight
session.screen0.window.focus.alpha:	255
session.screen0.window.unfocus.alpha:	128
session.screen0.fullMaximization:	false
session.screen0.edgeSnapThreshold:	0
session.screen0.windowScrollReverse:	false
session.screen0.showwindowposition:	true
session.screen0.resizeMode:	Bottom
session.screen0.antialias:	false
session.screen0.desktopwheeling:	true
session.screen0.followModel:	Ignore
session.screen0.menuDelay:	0
session.screen0.workspaceNames:	one,two,three,four,
session.screen0.menuMode:	Delay
session.screen0.focusLastWindow:	true
session.screen0.windowPlacement:	RowSmartPlacement
session.screen0.windowMenu:	
session.screen0.strftimeFormat:	%k:%M
session.screen0.workspacewarping:	true
session.screen0.workspaces:	4
session.screen0.menuDelayClose:	0
session.screen0.tabFocusModel:	ClickToTabFocus
session.screen0.rowPlacementDirection:	LeftToRight
session.screen0.autoRaise:	false
session.screen0.sloppywindowgrouping:	true
session.screen0.decorateTransient:	false
session.screen0.opaqueMove:	false
session.screen0.focusModel:	ClickFocus
session.screen0.rootCommand:	
session.screen0.windowScrollAction:	
session.screen0.focusNewWindows:	true
session.screen0.imageDither:	true
session.screen0.clickRaises:	true
session.screen0.colPlacementDirection:	TopToBottom
session.slitlistFile:	~/.fluxbox/slitlist
session.cacheMax:	200l
session.cacheLife:	5l
session.forcePseudoTransparency:	false
session.keyFile:	~/.fluxbox/keys
session.tabs:	true
session.focusTabMinWidth:	0
session.doubleClickInterval:	250
session.groupFile:	~/.fluxbox/groups
session.autoRaiseDelay:	250
session.styleFile:	/usr/local/share/fluxbox/styles/BlueNight
session.tabPadding:	0
session.styleOverlay:	~/.fluxbox/overlay
session.useMod1:	true
session.opaqueMove:	False
session.ignoreBorder:	false
session.colorsPerChannel:	4
session.numLayers:	13
session.tabsAttachArea:	Window
session.appsFile:	~/.fluxbox/apps
session.imageDither:	True
session.menuFile:	~/.fluxbox/menu
EOF

} fi;


chown -R $uadJ:$uadJ /home/$uadJ/.fluxbox/

if (test ! -f /home/$uadJ/.Xdefaults) then {
		cat > /home/$uadJ/.Xdefaults <<EOF
// Con base en http://dentarg.starkast.net/files/configs/dot.zshrc

XTerm*color0:                   #000000
XTerm*color1:                   #bf7276
XTerm*color2:                   #86af80
XTerm*color3:                   #968a38
XTerm*color4:                   #3673b5
XTerm*color5:                   #9a70b2
XTerm*color6:                   #7abecc
XTerm*color7:                   #dbdbdb
XTerm*color8:                   #6692af
XTerm*color9:                   #e5505f
XTerm*color10:                  #87bc87
XTerm*color11:                  #e0d95c
XTerm*color12:                  #1b85d6
XTerm*color13:                  #ad73ba
XTerm*color14:                  #338eaa
XTerm*color15:                  #f4f4f4
XTerm*colorBD:                  #ffffff
XTerm*foreground:               #000000
XTerm*background:               #ffffff
XTerm*font:                     shine2.se
XTerm*boldMode:                 false
XTerm*scrollBar:                false
XTerm*colorMode:                on
XTerm*dynamicColors:            on
XTerm*highlightSelection:       true
XTerm*eightBitInput:            false
XTerm*metaSendsEscape:          false
XTerm*oldXtermFKeys:            true
EOF
		chown -R $uadJ:$uadJ /home/$uadJ/.Xdefaults
} fi;


