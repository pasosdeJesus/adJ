
5.6
===

* X Recompilar /usr/sbin/{httpd,ldapd,nginx,nsd,nsd-checkzone,nsd-control,openssl,relayd,smtpd,unbound*} y paquetes para asegurar que usan libssl 27.0
* Usar freetype 2.5.5 que no pudo ser incluida ni corregida en OpenBSD 5.6:
	http://marc.info/?l=openbsd-tech&m=142571609625736&w=2
* X Cambiar orden de tablas LC_TIME para que concuerde con _TimeLocale
  de /usr/include/sys/localedef.h más date añadido de penúltimo. 
* X LC_TIME que use formato localedef  

5.7
===

* Cambiar localedef para no requerir recode en Makefile de locale/cldr

Futuro
* LC_COLLATE con wchar y algoritmo de cotejación Unicode ?
* localedef al menos para cotejación ?
* xiphos debería incluir módulos por defecto.
* Paginas man en español

