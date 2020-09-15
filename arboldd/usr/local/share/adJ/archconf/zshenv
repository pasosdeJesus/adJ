local _path_ant="$PATH"

# configuracion local
[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local

if [[ $PATH != $_path_ant ]]; then
  # `colors` no se ha inicialiado, definir algunos manualmente
  typeset -AHg fg fg_bold
  if [ -t 2 ]; then
    fg[red]=$'\e[31m'
    fg_bold[white]=$'\e[1;37m'
    reset_color=$'\e[m'
  else
    fg[red]=""
    fg_bold[white]=""
    reset_color=""
  fi

  cat <<MENS >&2
${fg[red]}Advertencia:${reset_color} su archivo de configuración \`~/.zshenv.local' parece editar entradas de PATH.
Por favor mueva esa configuración a \`.zshrc.local' con algo como:
  ${fg_bold[white]}cat ~/.zshenv.local >> ~/.zshrc.local && rm ~/.zshenv.local${reset_color}

(called from ${(%):-%N:%i})

MENS
fi

unset _path_ant
