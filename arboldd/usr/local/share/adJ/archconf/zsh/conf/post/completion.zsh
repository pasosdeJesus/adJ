# carga funciones de completacion
fpath=(~/.zsh/completion /usr/local/share/zsh/site-functions $fpath)

# completacion; usa cache si se actualizo en ultimas 24h
autoload -Uz compinit
if [[ -n $HOME/.zcompdump(#qN.mh+24) ]]; then
  compinit -d $HOME/.zcompdump;
else
  compinit -C;
fi;

# deshabilita funciones integradas con zsh de mttols comando mcd
# que causaria conflicto
compdef -d mcd
