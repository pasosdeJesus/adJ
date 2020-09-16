Archivos de configuración para adJ con base en los dotfiles de thoughtbot
=========================================================================

Requerimientos
--------------

* Usar zsh como interprete de ordenes (su licenciamiento es estilo MIT
  que requiere crédito a diferencia de `pdksh`, el estándar de OpenBSD,
  que es de dominio público).
  * Si hace falta instala con `doas pkg_add zsh`
  * Ponlo como tu interprete de ordenes de inicio de sesión con:
    `chsh -s $(which zsh)`.
  * Tras esto sal y vuelve a ingresar a tu interprete de ordenes para
    empezar a usar `zsh`.  
  * Entre sus mejoras respecto a `pdksh` está mayor autocompletación con TAB 
    por ejemplo en las opciones de las ordenes.
    Prueba `ls -` y presiona TAB para ver opciones de `ls` y autocompletar.
* Usar `rcm` para manejar archivos de configuración (licencia BSD de 3 
  clausulas)
  * Si hace falta instala con `doas pkg_add rcm`
  * Crea el directorio `~/archconf-local` y allí deja copia de tus archivos
    de configuración, quitandoles el punto inicial y añadiendoles el
    posfijo `.local`, por ejemplo:
    ```
    mkdir ~/archconf-local/
    cp ~/.gitconfig ~/archconf-local/gitconfig.local
    ```
  * En las secciones siguientes verás como usarlo en detalle.
* Usar `neovim` como editor (usa licencia Apache que es menos restrictiva
  que la de vim)
  * Si hace falta instala con `doas pkg_add neovim`
  * Podrá leer la configuración de vim, pero manejará mejor ratón y 
    portapapeles y a futuro posibilitará edición estilo IDE.


Instalación
-----------

Copia estos archivos de configuración en el directorio `archconf`
de tu directorio personal

    cp -rf /usr/local/share/adJ/archconf ~/

Instala estos archivos de configuración de `~/archconf`, así como 
tus personalizaciones de `~/archconf-local` con:

    env RCRC=$HOME/archconf/rcrc rcup

Después de la instalación inicial, puedes ejecutar `rcup` sin establecer la
variable `RCRC` (`rcup` creará `~/.rcrc` con la ubicación para futuras
ejecuciones de `rcup`). 
[Ver ejemplo](https://github.com/thoughtbot/archconf/blob/master/rcrc).

Esta orden copiará estos archivos de configuración en tu directorio
personal, así como tus personalizaciones del directorio ~/archconf-local.

Al establecer la variable de entorno le indicas a `rcup` que al hacer
la copia use las opciones de configuración preestablecidas:

* Excluir los archivos `README.md` y `LICENSE`, que son parte
  del repositorio `archconf`, pero no son archivos de configuración.
* Dar precedencia a las modificaciones personales que por defecto están en
  `~/archconf-local`
* Por favor configura el archivo `rcrc` en caso de que quieras hacer
  modificaciones personales en un directorio distinto.


Actualización
-------------

Con cada nueva versión de adJ se recomienda revisar las actualizaciones
a estos archconf, copiarlos nuevamente a tu directorio `~/archconf`
y volver a ejecutar:

    rcup

De esta manera se copiaran nuevos archivos y se instalarán nuevas
extensiones neovim.
**Nota** _Debes_ ejecutar `rcup` después de descargar para asegurar
que todos los archivos de las extensiones queden instalados adecuadamente.
Puedes ejecutar `rcup` muchas veces, así que !actualiza pronto y actualiza
con frecuencia!


Haz tus personalizaciones
-------------------------

Tus personalizaciones deben ubicarse en `~/archconf-local`
deben terminar en `.local`, digamos:

* `~/archconf-local/alias.local`
* `~/archconf-local/gitconfig.local`
* `~/archconf-local/psqlrc.local` (proveemos `.psqlrc.local` en blanco 
   para prevenir que `psql` arroje un error, pero debes sobreescribir el 
   archivo con tu propia copia)
* `~/archconf-local/tmux.conf.local`
* `~/archconf-local/vimrc.local`
* `~/archconf-local/vimrc.bundles.local`
* `~/archconf-local/zshrc.local`
* `~/archconf-local/zsh/configs/*`

Por ejemplo, tu `~/archconf-local/alias.local` tal vez se vea así:

    # Productividad
    alias porhacer='$EDITOR ~/.porhacer'

Tu `~/archconf-local/gitconfig.local` tal vez se vea así:

    [alias]
      l = log --pretty=colored
    [pretty]
      colored = format:%Cred%h%Creset %s %Cgreen(%cr) %C(bold blue)%an%Creset
    [user]
      name = Juan Valdez
      email = juan@valdez.org

Tu `~/archconf-local/vimrc.local` tal vez se vea así:

    " Esquema de colores
    colorscheme github
    highlight NonText guibg=#060606
    highlight Folded  guibg=#0A0A0A guifg=#9090D0

Si prefieres prevenir la instalación de una extensión predeterminado de vim 
en `.vimrc.bundles`, puedes ignorarlo sacándolo con `UnPlug` en 
tu `~/.vimrc.bundles.local`.

    " No instalar vim-scripts/tComment
    UnPlug 'tComment'

`UnPlug` puede ser usado para instalar tu propia bifuración (_fork_) de una
extensión o para instalar una extensión compartida con opciones personalizadas 
distintas.

    " Sólo cargar vim-coffee-script si se ha creado un colchon Coffeescript
    UnPlug 'vim-coffee-script'
    Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }

    " Usar una bifuración personal de vim-run-interactive
    UnPlug 'vim-run-interactive'
    Plug '$HOME/plugins/vim-run-interactive'

Para extender tus ganchos `git`, crea archivos ejecutables en
`~/archconf-local/git_template.local/hooks/*`.

Tu `~/archconf-local/zshrc.local` tal vez se vea así:

    # cargar pyenv si está disponible
    if command -v pyenv &>/dev/null ; then
      eval "$(pyenv init -)"
    fi

Tu `~/archconf-local/vimrc.bundles.local` tal vez se vea así:

    Plug 'Lokaltog/vim-powerline'
    Plug 'stephenmckinney/vim-solarized-powerline'


Configuraciones para zsh
------------------------

Las configuraciones adicionales para zsh pueden ir en el directorio 
`~/archconf-local/zsh/configs`. Este tiene dos subdirectorios especiales: 
`pre` para archivos que deben ser cargados primero y `post`
para archivos que deben cargarse al final.

Por ejemplo, `~/archconf-local/zsh/configs/pre/virtualenv` hace uso de varias 
características del interprete de ordenes que tal vez se vean afectadas por 
tu configuración, por lo tanto cárgalo primero:

    # Carga la envolutar virtualenv 
    . /usr/local/bin/virtualenvwrapper.sh

Se pueden establecer teclas rápidas en `~/archconf-local/zsh/configs/keys`:

    # Usar grep desde cualquier parte con ^G
    bindkey -s '^G' ' | grep '

Algunos cambios, como `chpwd`, deben ocurrir en 
`~/archconf-local/zsh/configs/post/chpwd`:

    # Mostrar entradas de un directorio siempre que te cambies al mismo
    function chpwd {
      ls
    }

Este directorio es útil para combinar archconf de múltiples equipos de trabajo;
un equipo puede agregar el archivo `virtualenv`, otro el archivo 
`keys` y un tercero el archivo `chpwd`. 

El archivo `~/archconf-local/zshrc.local` se carga después de 
`~/archconf-local/zsh/configs`.


Configuraciones de vim y neovim
-------------------------------

De forma análoga al directorio de configuración para zsh antes descrito, vim
carga automáticamente los archivos del directorio 
`~/archconf-local/vim/plugin`.
Sin embargo, este no tiene el mismo soporte para los subdirectorios `pre` 
ni `post` que tiene nuestro `zshrc`.

Este es un `~/archconf-local/vim/plugin/c.vim` de ejemplo. Se carga cada 
vez que inicia vim, sin importar el nombre del archivo:

    # Indenta programas en C de acuerdo al estilo BSD sytle(9)
    set cinoptions=:0,t0,+4,(4
    autocmd BufNewFile,BufRead *.[ch] setlocal sw=0 ts=8 noet


¿Qué viene incluido?
--------------------

Configuración de [tmux](http://robots.thoughtbot.com/a-tmux-crash-course):

* Mejora la resolución del color.
* Elimina restos administrativos (nombre de sesión, nombre de máquina, tiempo) 
  de la barra de estado.
* Suaviza el color de la barra de estatus de verde a gris claro.

Configuración de [vim](http://www.vim.org/) y [neovim](http://neovim.io):

* [fzf](https://github.com/junegunn/fzf.vim) para búsqueda difusa de
  archivos/colchones/etiquetas.
* [Rails.vim](https://github.com/tpope/vim-rails) para una mejor navegación de
  la estructura de archivos de Rails vía `gf` y `:A` (alterno), `:Rextract`
  parciales,`:Rinvert` migraciones, etc.
* Ejecuta muchos tipos de pruebas 
  [desde vim]([https://github.com/janko-m/vim-test)
* Establece `<leader>` a un sólo espacio.
* Navega entre los últimos dos archivos con espacio-espacio
* Resaltado de sintaxis para Markdown, HTML, JavaScript, Ruby, Go, Elixir
  y más.
* Usa [Ag](https://github.com/ggreer/the_silver_searcher) en lugar de grep
  cuando esta disponible.
* Mapea `<leader>ct` para re-indexar 
  [Exuberant Ctags](http://ctags.sourceforge.net/).
* Usa [vim-mkdir](https://github.com/pbrisbin/vim-mkdir) para crear 
  automáticamente directorios no existentes antes de escribir el colchón.
* Usa [vim-plug](https://github.com/junegunn/vim-plug) para administrar 
  extensiones.

Configuración de [git](http://git-scm.com/):

* Agrega el alias `create-branch` para crear ramas.
* Agrega el alias `delete-branch` para borrar ramas.
* Agrega el alias `merge-branch` para fusionar las ramas en `master`.
* Agrega el alias `up` para ejecutar `fetch` y `rebase` de la rama
  `origin/master` en una rama de trabajo.
  Usa `git up -i` para que sea modo interactivo.
* Agrega el gancho `post-{checkout,commit,merge}` para re-indexar tus ctags.
* Agrega atajos `pre-commit` y `prepare-commit-msg` que delegan hacia tu
  configuración local.
* Agrega el alias `trust-bin` para anexar el `bin/` de un proyecto al `$PATH`.

Configuración de [Ruby](https://www.ruby-lang.org/en/):

* Agrega atajos a binarios (_binstubs_) confiables al `PATH`.

Alias para el interprete de ordenes:

* `b` es `bundle`.
* `gemil` simplifica `doas gem install --install-dir ruta gema`, 
  la ruta destino será indicada por el archivo de configuración 
  `~/.bundle/config`. Por ejemplo si `~/.bundle/config` incluye 
  `BUNDLE_PATH: "/var/www/bundler/"`, al ejecutar
  ```
  gemil puma
  ```
  en realidad se ejecutará
  ```
  doas gem install --install-path /var/www/bundler/ruby/2.7 puma
  ```
* `g` sin argumentos es `git status` y con argumentos funciona como `git`.
* `migrate` es `rake db:migrate && rake db:rollback && rake db:migrate`.
* `mcd` crea un directorio y va a él.
* `replace foo bar **/*.rb` para buscar y reemplazar en una lista 
   dada de archivos.
* `tat` para adjuntar a una sesión de tmux llamada igual que el directorio 
   actual.
* `v` para `nvim`.


Gracias
-------

Gracias [Contribuyentes](https://github.com/thoughtbot/archconf/contributors)!
Además, gracias a Corey Haines, Gary Bernhardt, y otros por compartir sus
archconf y otros archivos de ordenes de los cuales obtuvimos inspiración
para diversos elementos de este proyecto.

Licencia
--------

Los derechos de reproducción de dotfiles © 2009-2017 son de thoughtbot. 
Es código de fuentes abiertas y puede redistribuirse 
bajo los términos especificados en el archivo
[LICENSE](https://github.com/thoughtbot/dotfiles/blob/master/LICENSE)

Acerca de thoughtbot
--------------------

![thoughtbot](http://presskit.thoughtbot.com/images/thoughtbot-logo-for-readmes.svg)

dotfiles es mantenido y financiado por thoughtbot, inc.
Los nombres y los logos de thoughtbot son marca registrada de thoughtbot, inc.

Amamos el código de fuentes abiertas!
Vea [nuestros otros proyectos](https://github.com/thoughtbot).
Estamos [disponibles para ser contratados](https://thoughtbot.com/hire-us?utm_source=github).

