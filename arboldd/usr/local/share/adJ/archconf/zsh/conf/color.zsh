# constates de color
autoload -U colors
colors
which colorls > /dev/null 2>&1
if [[ "$?" = "0" ]]; then
  export CLICOLOR=1
  alias ls=colorls
fi
