# Reglas comunes para crear distribución de fuentes y publicar.  
# Para incluir en Makefile.
# Dominio público. Sin garantías. structio-devel@lists.sourceforge.net

# Variables requeridas:

# PROYECTO nombre corto del proyecto 
# PRY_VERSION version
# ACT_PROC regla para actualizar, las disponibles en este script son act-scp y act-ncftpput
# GENDIST Reglas por iniciar anates de generar distribución (e.g Derechos.txt)
# LIMPIADIST2 Reglas para ejecutar después de haber limpiado directorio (para limpiar otros archivos que no deben incluirse en fuentes distribuidas).
# USER, ACTHOST and ACTDIR Usuario, máquina y directorio en Internet para actualizar
# GENACT Reglas por iniciar antes de actualizar sitio en Internet (e.g index.html)
# FILESACT Archivos por transmitir a ACTHOST:ACTDIR


# Reglas requeridas en el Makefile:
# limpiadist 	Que debe limpiar todo excepto los archivos que deben ir
# 		en una distribución de fuentes.


dist: $(GENDIST) $(PROYECTO)-$(PRY_VERSION).tgz

$(PROYECTO)-$(PRY_VERSION).tgz: 
	rm -f $(PROYECTO)-$(PRY_VERSION).tgz
	rm -rf $(PROYECTO)-$(PRY_VERSION)
	a=`echo *`; \
	mkdir -p $(PROYECTO)-$(PRY_VERSION); \
	cp -rf $$a $(PROYECTO)-$(PRY_VERSION)
	find $(PROYECTO)-$(PRY_VERSION) -name "CVS" | xargs rm -rf
	if (test "$(LIMPIADIST2)" != "") then { cd $(PROYECTO)-$(PRY_VERSION); make $(LIMPIADIST2);} fi;
	cd $(PROYECTO)-$(PRY_VERSION); make limpiadist
	tar cvfz $(PROYECTO)-$(PRY_VERSION).tgz $(PROYECTO)-$(PRY_VERSION)
	rm -rf $(PROYECTO)-$(PRY_VERSION)

act: $(GENACT) $(ACT_PROC)

act-scp:
	$(SCP) $(FILESACT) $(USER)@$(ACTHOST):$(ACTDIR)

act-ncftpput:
	$(NCFTPPUT) -u $(USER) $(ACTHOST) $(ACTDIR) $(FILESACT)
