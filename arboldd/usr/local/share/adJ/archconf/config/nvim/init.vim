set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" Soporta General Bible Format en XML ver
" https://github.com/pasosdeJesus/biblia_dp/blob/master/herram/vim/ftplugin/gbfxml.vim
au! BufRead,BufNewFile *.gbfxml       setfiletype gbfxml

