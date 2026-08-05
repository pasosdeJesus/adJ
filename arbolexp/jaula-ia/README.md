Para ejecutar programas gráficos en la jaula (después de haber copiado X* del
instaladro y que ldconfig haya configurado /usr/X11R6/lib):

1. En anfitrión ejecutar Xephyr :1 -listen tcp -ac
Eso abrirá una ventana con un servidor X anidado (ideal para ejecutar
aplicaciones gráficas en chroots y VM).

    2. En la jaula chroot:
export DISPLAY=127.0.0.1:1

