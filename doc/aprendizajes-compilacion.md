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
