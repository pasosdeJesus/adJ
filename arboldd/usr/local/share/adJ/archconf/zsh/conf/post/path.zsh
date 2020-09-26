# asegura que directorio de binarios de archivos de configuracion carga primero
PATH="$HOME/.bin:/usr/local/sbin:$PATH"

# mkdir .git/safe en la raiz de repositorios en los que confia
PATH=".git/safe/../../bin:$PATH"

export -U PATH
