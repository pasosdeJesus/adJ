# da acceso a ^Q
stty -ixon

# modo vi 
bindkey -v
bindkey "^F" vi-cmd-mode

# atajos de teclado utiles
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^K" kill-line
bindkey "^R" history-incremental-search-backward
bindkey "^P" history-search-backward
bindkey "^Y" accept-and-hold
bindkey "^N" insert-last-word
bindkey "^Q" push-line-or-edit
bindkey -s "^T" "^[Idoas ^[A" 
