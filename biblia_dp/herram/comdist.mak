# Reglas comunes para crear distribución de fuentes y publicar.  
# Para incluir en Makefile.
# Dominio público. Sin garantías. structio-info@lists.sourceforge.net

# Variables requeridas (fuera de otras con programas) 

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


distcvs:
	$(CVS) -z3 co $(PROYECTO) 
	$(MV) $(PROYECTO) $(PROYECTO)-$(PRY_VERSION)
	$(FIND) ./$(PROYECTO)-$(PRY_VERSION)/ -name CVS | xargs rm -rf 
	$(TAR) cvfz $(PROYECTO)-$(PRY_VERSION).tar.gz $(PROYECTO)-$(PRY_VERSION)
	$(RM) -rf $(PROYECTO)-$(PRY_VERSION)

dist:
	$(RM) -f $(PROYECTO)-$(PRY_VERSION).tar.gz
	$(RM) -rf $(PROYECTO)-$(PRY_VERSION)
	if (test "$(LISTA_DIST)" = "") then { a=`echo *`; } else { a="$(LISTA_DIST)"; } fi; \
	$(MKDIR) -p $(PROYECTO)-$(PRY_VERSION); \
	$(CP) -rf $$a $(PROYECTO)-$(PRY_VERSION)
	$(FIND) $(PROYECTO)-$(PRY_VERSION) -name "CVS" | xargs rm -rf
	if (test "$(LIMPIADIST2)" != "") then { cd $(PROYECTO)-$(PRY_VERSION); $(MAKE) $(LIMPIADIST2);} fi;
	$(CP) Make.inc $(PROYECTO)-$(PRY_VERSION); cd $(PROYECTO)-$(PRY_VERSION); $(MAKE) limpiadist; rm -f Make.inc
	$(TAR) cvfz $(PROYECTO)-$(PRY_VERSION).tar.gz $(PROYECTO)-$(PRY_VERSION)
	$(RM) -rf $(PROYECTO)-$(PRY_VERSION)


distregr: $(PROYECTO)-$(PRY_VERSION).tar.gz
	if (test -d $(PROYECTO)-$(PRY_VERSION)) then {\
		echo "No debe exisitr directorio $(PROYECTO)-$(PRY_VERSION)"; \
	} fi;
	$(TAR) xvfz $(PROYECTO)-$(PRY_VERSION).tar.gz
	$(CP) confv.sh $(PROYECTO)-$(PRY_VERSION)
	cd $(PROYECTO)-$(PRY_VERSION) && \
	./conf.sh && $(MAKE) && $(MAKE) regr && \
	cd .. && \
	$(RM) -rf $(PROYECTO)-$(PRY_VERSION) && \
	echo "=============================" && \
	echo "Funciona!" && \
	echo "============================="


act: $(GENACT) $(ACT_PROC)
	if (test "$(OTHER_ACT)" != "") then { $(MAKE) $(OTHER_ACT); } fi;

act-scp:
	if (test "$(SCP)" = "") then { echo "Falta programa scp, instale y configure de nuevo con conf.sh"; exit 1; } fi;
	$(SCP) $(FILESACT) $(USER)@$(ACTHOST):$(ACTDIR)

act-ncftpput:
	if (test "$(NCFTPPUT)" = "") then { echo "Falta programa ncftpput, instale y configure de nuevo con conf.sh"; exit 1; } fi;
	$(NCFTPPUT) -u $(USER) $(ACTHOST) $(ACTDIR) $(FILESACT)
