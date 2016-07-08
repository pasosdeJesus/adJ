#adJ - Aprendiendo de Jesús.
Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos
y Educativas y que anhelamos fuese usada por Jesús durante el Milenio.

###Versión: 5.8p1
Fecha de publicación: 8/Jul/2016

##NOVEDADES

Con respecto a adJ 5.8

* Parches al sistema base hasta el 7.Jun.2016, que cierran las 9 fallas de 
  seguridad y las 7 de robustez resueltas para fuentes de OpenBSD descritas 
  en <http://www.openbsd.org/errata58.html>. Igualmente recompilados binarios 
  que dependían de librería con falla (```libcrypto```): ```isakmpd```, 
  ```iked``` y  ```ftp``` y que serían susceptibles a denegación de servicio.  
  Los binarios distribuidos de OpenBSD 5.8 no resuelven estas fallas. 
  Las 6 fallas de seguridad posteriores al 10.Mar.2016 y varias de robustez
  también afectan OpenBSD 5.9, los binarios distribuidos de esa versión
  tampoco los resuelven.
* Más paquetes retroportados y recompilados para cerrar fallas de seguridad y
  actualizar: 
	freetds 0.95.18, mariadb 10.0.22 
* Paquetes actualizados para cerrar fallas y resolver problemas con 
  certificados y protocolos SSL y TLS:
	nginx-1.910, php-5.6.23, openldap-client-2.4.43
* Nuevo paquete letsencrypt y otros de los que depende retroportados
  de OpenBSD 5.9 para facilitar uso de certificados SSL gratuitos de
  https://letsencrypt.org

Puede ver más novedades de adJ 5.8 en 
	<https://github.com/pasosdeJesus/adJ/blob/v5.8/Novedades.md>

Y novedades de adJ con respecto a OpenBSD en:
	<https://github.com/pasosdeJesus/adJ/blob/v5.8/Novedades_OpenBSD.md>


