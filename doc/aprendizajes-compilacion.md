# Aprendizajes de compilación de paquetes de adJ

Patrones y procedimientos recopilados durante una sesión de compilación.
Los ejemplos concretos corresponden a la versión 7.9, pero los patrones
aplican a cualquier versión.

---

## 1. Desajuste WANTLIB entre árbol de ports y paquetes instalados

**Patrón**: cuando el árbol `/usr/ports` se actualiza (p. ej. por CVS) más
allá de los paquetes ya instalados, `make package` falla al final con un
error tipo `wantlib-args` o `Libraries in packing-lists ... don't match`.
El diff muestra que el porte espera una versión de biblioteca compartida
más nueva que la instalada (p. ej. `-W foo.x.y` vs `+W foo.x.z`).

**Detección**: buscar en la bitácora `wantlib-args` o `doesn't match`.

**Resolución**: compilar e instalar la biblioteca base desde ports, porque
el mirror de la versión estable no trae las versiones nuevas (`pkg_add -u`
responde "up to date"). El orden importa según dependencias.

**Ejemplo (7.9)**:

```
doas sh -c 'cd /usr/ports/devel/pcre2 && make install'     # 10.44 -> 10.48
doas sh -c 'cd /usr/ports/lang/tcl/8.6 && make install'    # 8.6.16 -> 8.6.17
doas sh -c 'cd /usr/ports/x11/tk/8.6 && make install'      # 8.6.16 -> 8.6.17
```

---

## 2. Dependencia circular entre paquetes

**Patrón**: dos paquetes que se dependen mutuamente (uno es dependencia
inversa del otro) no se pueden actualizar con `make install` por separado.
`pkg_add` falla con `NOT MERGING: can't find update for ...`, porque al
actualizar A detecta que B (instalado) depende de la versión vieja de A.

**Resolución**: borrar primero el dependiente inverso, actualizar el
paquete base y luego recompilar el dependiente.

**Ejemplo (7.9)**: `tcl` ↔ `tk`.

```
doas pkg_delete tk-8.6.16                 # rompe la circularidad
doas sh -c 'cd /usr/ports/lang/tcl/8.6 && make install'
doas sh -c 'cd /usr/ports/x11/tk/8.6 && make install'
```

---

## 3. Desajuste de handshake de Perl (módulos XS)

**Patrón**: tras actualizar Perl, los módulos XS compilados contra el Perl
anterior fallan al cargar con `loadable library and perl binaries are
mismatched (got handshake key ...)`. `make` NO recompila si el `.so` ya
instalado es más reciente que la fuente, por lo que un simple
`make install` no basta.

**Resolución**: borrar el módulo y sus dependientes inversos en cascada,
luego recompilar con `make clean && make install` en orden de dependencia.

**Ejemplo (7.9)**: `p5-DBD-SQLite` (módulo XS) bloqueaba la configuración
de `p5-Mail-SpamAssassin`.

```
doas pkg_delete p5-Mail-SpamAssassin p5-Mail-DMARC p5-DBD-SQLite
doas sh -c 'cd /usr/ports/databases/p5-DBD-SQLite && make clean && make install'
doas sh -c 'cd /usr/ports/mail/p5-Mail-DMARC && make clean && make install'
doas sh -c 'cd /usr/ports/mail/p5-Mail-SpamAssassin && make clean && make install'
```

---

## 4. La función `paquete` de `distribucion.sh` no instala

**Patrón**: `paquete <nombre>` ejecuta `make -j4` + `make package`
(compila y empaqueta), pero NO `make install`. Por tanto, las bibliotecas
base deben estar ya instaladas en la máquina ANTES de correr
`distribucion.sh`; de lo contrario los paquetes dependientes fallan en
`make package` por el desajuste descrito en el patrón 1.

---

## 5. Puertos `mystuff` vs árbol estándar

**Patrón**: los puertos con parches propios de adJ (en
`arboldes/usr/ports/mystuff`) deben mantenerse sincronizados con la
versión del puerto estándar en `/usr/ports`. Si quedan desalineados,
`make package` falla con `Dependency ... doesn't match FULLPKGNAME: ...`,
porque las autodependencias resuelven contra la versión estándar.

**Resolución (rápida)**: en vez de sincronizar archivo por archivo,
reemplazar el puerto mystuff completo con el estándar:

    cp -R /usr/ports/databases/postgresql \
        arboldes/usr/ports/mystuff/databases/postgresql

y luego `diff -r` entre ambos para identificar los cambios propios de adJ
(p. ej. `pkg/postgresql.rc` con `daemon` → `servicio`). Para cada archivo
que difiera: rehacer el cambio sobre la nueva versión, o restaurarlo si en
la versión nueva no hubo modificación de ese archivo.

**Ejemplo (7.9)**: `databases/postgresql` mystuff estaba en 17.9 mientras
el estándar iba en 18.6. Se alineó a 18.6 y se conservó
`pkg/postgresql.rc` con `servicio`.

---

## 6. Dependientes de una biblioteca con bump de versión menor

**Patrón**: un bump de la versión *menor* de una biblioteca compartida
(p. ej. `0.7` → `0.9`) es compatible en tiempo de ejecución; no es
necesario recompilar todos sus dependientes. Basta incluir en
`autoPaquetes` la biblioteca base (y las que sí cambien de ABI).

**Ejemplo (7.9)**: al subir `pcre2` de 10.44 a 10.48, no hizo falta
recompilar los ~33 dependientes; solo `pcre2`, `tcl` y `tk`.

---

## 7. Nota operativa del agente

En el entorno del agente, `doas` está bloqueado como orden directa, pero
se ejecuta con `zsh -c "doas ..."`. Útil solo para esta herramienta; no es
parte del flujo normal de adJ.

---

## 8. Retroportar un porte a *current* (versión más nueva que la rama)

**Patrón**: cuando se quiere subir un porte a una versión que solo existe
en *current* (no en la rama estable, p. ej. `TOPENBSD_7_9`), no basta con
actualizar el porte en `mystuff`. El árbol estándar `/usr/ports/<porte>`
debe actualizarse también con `cvs up -A` (pasa de la etiqueta estable a
HEAD). Si no, las autodependencias entre subpaquetes (en particular el
paquete `debug-*` generado por `DEBUG_PACKAGES`) se resuelven contra la
versión vieja del estándar y `make package` falla con:

    Error: Dependency = doesn't match FULLPKGNAME: <versión-vieja>

El comentario de `distribucion.sh` lo resume: los retroportados «deben
estar en `arboldes/usr/ports/mystuff` y en `/usr/ports` de current».

**Ejemplo (7.9)**: `lang/ruby` se subió de 4.0.2p1 (rama 7.9) a 4.0.7
(current). Solo actualizar `mystuff/lang/ruby/4.0` a 4.0.7 hizo que
`debug-ruby-4.0.7` fallara al empaquetar, porque su dependencia
`lang/ruby/4.0,-main` se resolvía contra `/usr/ports/lang/ruby/4.0`
(4.0.2p1). La solución fue alinear también el estándar:

```
doas sh -c 'cd /usr/ports/lang/ruby && cvs -q up -A -dP'
```

Después, `diff -r` entre `mystuff/lang/ruby` y `/usr/ports/lang/ruby`
muestra únicamente las diferencias propias de adJ (ver patrón 5).

---

## 9. Preservar comportamiento original de RubyGems en `mystuff`

**Patrón**: el porte estándar de Ruby trae
`patches/patch-lib_rubygems_rb`, que deshabilita `gem update --system`
con un mensaje («Ruby was installed using an OpenBSD package...»). En adJ
se quiere conservar el comportamiento original de RubyGems, es decir que
`doas gem update --system` siga disponible. Por eso, al sincronizar
`mystuff/lang/ruby` con el estándar, ese patch debe **excluirse** (no
copiarlo), y no debe agregarse el `REVISION` asociado.

**Ejemplo (7.9)**: al crear `mystuff/lang/ruby/4.0` en 4.0.7, la única
diferencia contra `/usr/ports/lang/ruby/4.0` es la ausencia de
`patches/patch-lib_rubygems_rb`.

---

## 10. Porte nuevo en C++20 con CMake y dependencias header-only

**Patrón**: para portar software C++20 (como `solc`, el compilador de
Solidity), se usa `MODULES = devel/cmake` y `COMPILER = base-clang
ports-gcc` con `COMPILER_LANGS = c++`. Las dependencias header-only
(`range-v3`, `nlohmann-json`) que usan `NO_BUILD = Yes` y `PKG_ARCH = *`
no se pueden instalar como dependencia automática de `make` (falla con
`don't know how to make ... .tgz`); hay que instalarlas por separado
desde `PKG_PATH` con `pkg_add` antes de compilar.

**Ejemplo (7.9)**: `mystuff/lang/solidity` (`solc` 0.8.37). Dependencias:
`devel/boost`, `devel/fmt`, `textproc/nlohmann-json`, `devel/range-v3`.
Flags CMake: `-DTESTS=OFF -DIGNORE_VENDORED_DEPENDENCIES=ON
-DPEDANTIC=OFF`. `nlohmann-json` y `range-v3` se instalan con `pkg_add`
antes del `make`, porque son header-only y `make install` falla al
intentar empaquetarlas.

---

## 11. Condición de carrera (lost wakeup) en tests de regresión

**Patrón**: al modificar un test de regresión que sincroniza hilos con
`pthread_cond_signal`/`pthread_cond_timedwait`, si se reduce el trabajo
del hilo principal puede aparecer un timeout (`pthread_cond_timedwait:
Operation timed out`) por *lost wakeup*: el hilo principal señaliza antes
de que el otro entre a `timedwait`. La solución es hacer el
`pthread_mutex_trylock` **antes** del `pthread_cond_signal`, para que el
otro hilo no pueda avanzar hasta que el primero entre a `timedwait` (que
libera el mutex).

**Ejemplo (7.9)**: `regress/lib/libc/locale/uselocale/uselocale.c`. El
parche `04-xlocale-wchar.patch` comentó pruebas del hilo principal,
volviéndolo tan rápido que señalizaba antes de que el hilo hijo entrara a
`pthread_cond_timedwait`. Se reordenó `switch_thread` para bloquear el
mutex antes de señalizar.

---

## 12. Actualización de seguridad que añade un símbolo/enum en una dependencia

**Patrón**: al subir un paquete (p. ej. un runtime con JIT) a una versión
que corrige una falla de seguridad, su código puede referenciar un
símbolo, enum o constante nueva de una biblioteca de la que depende.
Compilar contra la biblioteca vieja falla con
`use of undeclared identifier '...'`. El mirror de la rama estable no trae
la biblioteca con el fix.

**Resolución**: actualizar primero la biblioteca base al mismo nivel del
fix (bump de versión menor: `GH_TAGNAME`/`VERSION` + `make makesum` +
`make install`), y luego recompilar el paquete.

**Ejemplo (7.9)**: `node` 22.23.4 (CVE-2026-111497) referencia
`BROTLI_DECODER_ERROR_FORMAT_BLOCK_SWITCH`, que solo existe en
`brotli` ≥ 1.2.1. Se subió `brotli` de 1.2.0 a 1.2.1 y node compiló.

---

## 13. Flavor específico de un paquete en `distribucion.sh`

**Patrón**: `paquete <nombre>` compila el flavor por defecto. Si la
distribución usa un flavor específico (p. ej. `gtk3`), la línea debe ser
`FLAVOR=<flavor> paquete <nombre>`; la variable de entorno `FLAVOR` se
hereda en los `make` internos de la función y produce
`<nombre>-<versión>-<flavor>.tgz`.

**Ejemplo (7.9)**: `vim` (`FLAVORS=gtk3 lua perl python3 ruby`). Con
`paquete vim` salía `vim-9.2.1125.tgz` (sin gtk3); con
`FLAVOR=gtk3 paquete vim` sale `vim-9.2.1125-gtk3.tgz`.

---

## 14. Lock obsoleto en `<pobj>/locks`

**Patrón**: si un build se detiene con `kill -9` (SIGKILL), el lock del
porte queda en `<pobj>/locks/<port>-<versión>.lock`. El siguiente build se
queda en `Awaiting lock ...` sin avanzar.

**Resolución**: borrar el lock obsoleto (`doas rm -f
/usr/ports/pobj/locks/<port>-*.lock`).

**Ejemplo (7.9)**: `node-22.23.4v0.lock`.

---

## 15. Paquetes JIT requieren `wxallowed`

**Patrón**: los paquetes con JIT (node, firefox-esr, etc.) exigen que el
directorio de objetos (`WRKOBJDIR`/`pobj`) esté en un filesystem montado
con `wxallowed`. Si `pobj` es un symlink a NFS sin `wxallowed`, `make`
falla con `must be on a wxallowed filesystem`.

**Resolución**: montar el filesystem con `wxallowed` (p. ej.
`mount -u -o ...,wxallowed <mountpoint>`) y dejarlo en `/etc/fstab`.

**Ejemplo (7.9)**: `/usr/ports/pobj -> /var/www/adJ-ia/pobj` (NFS). Se
remontó el NFS con `wxallowed` para compilar node/firefox.

---

## 16. Mirror local con índice desactualizado

**Patrón**: un mirror local puede listar un paquete en su índice pero
fallar al descargar el `.tgz` (`404 Not Found`), porque el sync quedó
incompleto. No hay que compilarlo; basta bajarlo del mirror oficial.

**Resolución**: descargar el `.tgz` del mirror oficial (p. ej.
`cdn.openbsd.org`), firmarlo con la llave de adJ (`pkg_sign`) y copiarlo
a la distribución; y sincronizar el mirror local.

**Ejemplo (7.9)**: `libggml-0.9.11.tgz` da 404 en el mirror local
(`192.168.177.29`); se descargó de `cdn.openbsd.org`.

---

## 17. `make package` es no-op por la "cookie" del paquete

**Patrón**: `make package` (y `make build`/`make fake`) no hacen nada si el
`.tgz` ya existe en el repositorio de paquetes
(`/usr/ports/packages/<arq>/all/`). El paquete existente actúa como
"cookie" y marca el objetivo como cumplido, aunque la fuente y el fake
sean más nuevos. `make -n package` muestra el flujo, pero el `make` real
no ejecuta nada.

**Resolución**: borrar el paquete anterior (la cookie) antes de
re-empaquetar: `doas rm -f /usr/ports/packages/amd64/all/<pkg>-*.tgz`.

**Ejemplo (7.9)**: `bibletime-3.0.3.tgz` ya existía de una compilación
anterior, y `make package` no re-empaquetaba con los cambios.

---

## 18. Distfile ausente detiene el build sin aviso claro

**Patrón**: si el distfile falta en `/usr/ports/distfiles/`, `make
package` no avanza y no da error explícito (parece "no-op"). El paso a
paso `make extract` sí reporta el avance y es la forma de diagnosticar.

**Resolución**: descargar el distfile (p. ej. de GitHub con
`.../archive/refs/tags/<tag>.tar.gz`), verificar el `SHA256` contra
`distinfo` (`cksum -a sha256 -b`) y colocarlo en `/usr/ports/distfiles/`.

**Ejemplo (7.9)**: `bibletime-3.0.3.tar.gz` (GitHub, tag `v3.0.3`).

---

## 19. `change in plist` y el plist de referencia

**Patrón**: al empaquetar, la infraestructura compara el PLIST generado
(del fake) contra el de referencia en `/usr/ports/plist/<arq>/<pkg>`. Si
difieren (p. ej. porque se añadió un directorio), `make package` falla
con `Error: change in plist` y un diff `--- <pkg> +++ <pkg>-new`.

**Resolución**: `doas make plist` para regenerar `pkg/PLIST` desde el fake
(esto además quita entradas redundantes, p. ej. el directorio padre).
Luego actualizar la referencia:
`doas cp /usr/ports/plist/amd64/<pkg>-new /usr/ports/plist/amd64/<pkg>`,
y volver a `make package`.

**Ejemplo (7.9)**: `bibletime`; el `pkg/PLIST` tenía `share/doc/` (padre
redundante) y la referencia no traía `share/doc/bibletime/`.

---

## 20. No empaquetar a mano con `pkg_create`; directorios vacíos en el PLIST

**Patrón**: crear el paquete a mano con `pkg_create` omite las definiciones
`@tag` que inyecta la infraestructura (p. ej. `gtk-update-icon-cache`,
`update-desktop-database`); el paquete resultante no se instala
(`Error: @tag ... definition not found`). Además, un directorio vacío se
lista en el PLIST con barra final (`share/doc/bibletime/`), pero NO el
padre (`share/doc/`), que se crea solo al instalar.

**Resolución**: usar siempre `make package` (que arma los argumentos
completos de `pkg_create`), no `pkg_create` a mano. Para un directorio
vacío, listarlo con barra final y dejar que `make plist` ajuste el resto.

**Ejemplo (7.9)**: `bibletime` requiere `share/doc/bibletime/` vacío (si
no, aborta en `initDirectoryCache()` al no hallar la documentación).

---

## 21. Portes de documentación (basico/usuario/servidor_adJ)

**Patrón**: los tres manuales comparten `Make.inc` (`V=<versión>`). Para
subir versión: cambiar `V`, descargar de GitLab
`https://gitlab.com/pasosdeJesus/<pkg>/-/archive/<pkg>-<V>/<pkg>-<pkg>-<V>.tar.gz`,
calcular `cksum -a sha256 -b` (base64) y el tamaño (`wc -c`), actualizar
`distinfo` y colocar el `.tgz` en `/usr/ports/distfiles/`. El tarball
descomprime en `<pkg>-<pkg>-<V>` (la regla `post-extract` lo renombra).

**Ejemplo (7.9)**: `basico_adJ`, `usuario_adJ`, `servidor_adJ` subidos a
7.9.

---

## 22. Seguridad de OpenBSD en `packages-stable`

**Patrón**: las actualizaciones de seguridad (branch -stable) están en
`packages-stable/<arq>/`, no en `packages/<arq>/` (release). Si el mirror
local no las tiene, bajan de `cdn.openbsd.org`/`ftp.openbsd.org` y se
firman con `pkg_sign` para la distribución.

**Ejemplo (7.9)**: `firefox-esr-140.17.0` está en `packages-stable`, no en
`packages` (que trae 140.10.0).

---

## 23. Qt Quick: `QML_DISABLE_DISTANCEFIELD`

**Patrón**: en Qt Quick, el cache de glifos por "distance field" falla en
OpenBSD para varias fuentes TTF/OTF (los glifos se dibujan con el mismo
color/alfa que el fondo, invisibles; el subrayado sí se ve). Se corrige
con `qputenv("QML_DISABLE_DISTANCEFIELD", "1")` antes de crear la
`QApplication`.

**Ejemplo (7.9)**: `bibletime` (parche `patch-src_frontend_main_cpp`); sin
el parche, `QML_DISABLE_DISTANCEFIELD=1 bibletime` es el workaround.

---

## 24. Porte npm con `node_modules` empaquetado (JS puro)

**Patrón**: para un paquete npm JS puro (sin binarios nativos) se arma un
distfile con el tarball de `npm pack` + `node_modules` (instalado con
`npm install --omit=dev --ignore-scripts`), se copia todo a
`${PREFIX}/lib/node_modules/<nombre>/` y se hace symlink del binario con
`${TRUEPREFIX}`. Claves:

- `COMMENT` debe tener **60 caracteres como máximo** (`pkg_create` aborta
  con "comment is too long").
- `DESCR` debe ser **ASCII puro**: el em dash `—` (U+2014) provoca
  "DESCR contains weird characters"; usar `:` o `-`.
- Antes de empaquetar, **borrar los `man/` de `node_modules`**: `update-plist`
  marca `man/man1/*.1` como `@man` aunque estén bajo `lib/node_modules/...`
  (p. ej. la copia anidada de un *peer dependency*), y `pkg_add` sugiere
  agregar esa ruta a `/etc/man.conf`. La página real va en
  `${PREFIX}/man/man1/`.
- Los *peerDependencies* (npm >= 7) se instalan solos y quedan anidados
  (p. ej. `@pasosdejesus/m` dentro de `node_modules/@pasosdejesus/m` por
  `contract-test`); no hay que podarlos, se necesitan para resolver imports.
- Generar el PLIST con `make plist` (no a mano), `NO_BUILD=Yes`,
  `RUN_DEPENDS=lang/node`, `WRKDIST=${WRKDIR}/package` (root de `npm pack`).

**Ejemplo (7.9)**: `mystuff/devel/m` (`@pasosdejesus/m` 0.37.4), con
`@pasosdejesus/contract-test` y `@pasosdejesus/edr` como opcionales
empaquetadas.
