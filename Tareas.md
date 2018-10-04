
6.4
===
* Recompilar paquetes más actualizados en current como vlc:

cd /usr/ports/pobj/vlc-2.2.8/vlc-2.2.8
$ doas bin/vlc-cache-gen --lt-debug modules/                                                                                                               
vlc-cache-gen:vlc-cache-gen:93: libtool wrapper (GNU libtool) 2.4.2
vlc-cache-gen:vlc-cache-gen:114: newargv[0]: /usr/ports/pobj/vlc-2.2.8/vlc-2.2.8/bin/.libs/vlc-cache-gen                                                       
vlc-cache-gen:vlc-cache-gen:104: newargv[1]: modules/                                                                                                          
Segmentation fault (core dumped)  
$ doas gdb bin/.libs/vlc-cache-gen vlc-cache-gen.core
...
#0  newlocale (mask=32, locale=Variable "locale" is not available.
) at xlocale_private.h:145
145             obj->retain_count++;
(gdb) bt
#0  newlocale (mask=32, locale=Variable "locale" is not available.
) at xlocale_private.h:145
#1  0x00001afe48d0d4e1 in vlc_strerror ()
   from /usr/local/lib/libvlccore.so.3.0
#2  0x00001afe48cf7168 in module_list_free ()
   from /usr/local/lib/libvlccore.so.3.0
#3  0x00001afe48cf6a28 in module_list_free ()
   from /usr/local/lib/libvlccore.so.3.0
#4  0x00001afe48cf643e in module_config_free ()
   from /usr/local/lib/libvlccore.so.3.0
#4  0x00001afe48cf643e in module_config_free ()                                                                                                       [12/65299]
   from /usr/local/lib/libvlccore.so.3.0                                                                                                                       
#5  0x00001afe48c95cc7 in libvlc_InternalInit ()
   from /usr/local/lib/libvlccore.so.3.0                                                                                                                       
#6  0x00001afe2ec16fc3 in libvlc_new ()
   from /usr/local/lib/libvlc.so.3.0
#7  0x00001afba0300751 in main ()
   from /usr/ports/pobj/vlc-2.2.8/vlc-2.2.8/bin/.libs/vlc-cache-gen
(gdb) list
145             obj->retain_count++;
146             return (val);


* Intentar usar TIB_GET para maneter locale del thread (como hace
  implementación vacía de xlocale OpenBSD 6.2)

Futuro
======
* En documentacion garantizar que cubrimos lo del FAQ de OpenBSD
* LC_COLLATE con wchar y algoritmo de cotejación Unicode ?
* localedef al menos para cotejación ?
* xiphos debería incluir módulos por defecto.
* Páginas man en español

