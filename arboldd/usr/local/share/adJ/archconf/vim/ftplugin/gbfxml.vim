" Plugin para vim
" Lenguaje: gbfxml
" Mantenedor: Vladimir Támara (vtamara@pasosdeJesus.org)
" URL: http://traduccion.pasosdeJesus.org
" Last Change: 4/Ago/2003
" Liberado al dominio público

" Se basa en modo DocBook para vim

" CONFIGURACIÓN:
"
" 1. Agregar a ~/.vim/filetype.vim
" au! BufRead,BufNewFile *.gbfxml       setfiletype gbfxml
" 2. Copiar este archivo en ~/.vim/ftplugin/ con nombre gbfxml.vim
" 3. Copiar el archivo herram/vim/syntax/gbfxml.vim en ~/.vim/syntax/
"
" MODO DE USO
"
" Edite un archivo con extensión gbfxml
" - <b inserta una nueva referencia bibliografica es decir: 
"     <bib id="">
"       <tt></tt>
"       <author></author>
"       <editor></editor>
"       <otherbib></otherbib>
"     </bib>
" - <ci inserta una cita a una referencia bibliografica es decir:
"     <citebib id=""/>
" - <rb inserta una nota al pie de página es decir:
"     <rb xml:lang="es"><rf></rf></rb>
" - <t  inserta un traducción a español es decir:
"     <t xml:lang="es"></t>
" - <w3 inserta referencia strong a un articulo pero sin palabra en
"   español es decir:
"     <wi type="G" value="3588,,"/>
" - <w2 inserta referencia strong a la conjunción Y pero sin palabra en
"   español, es decir:
"     <wi type="G" value="2532,,"/>
" - <w1 inserta referencia strong a otra conjunión Y pero sin palabra en
"   español
"     <wi type="G" value="1161,,"/>
" - <wi pone la palabra siguiente entre marcado para agregar referencia
"   strong, es decir:
"     <wi type="G" value=",">laPalabraQueSigue</wi>


" Sólo carga plugin si el usuario lo desea y no se ha hecho antes
if exists("b:did_ftplugin")
	finish
endif
let b:did_ftplugin = 1

" Define tecla especial para mapeo de teclas 
if exists("xml_leader")
	let maplocalleader = xml_leader
else
	let maplocalleader = "<" 
endif

" Mapeo de teclas
if !exists("no_plugin_maps") && !exists("no_gbfxml_maps")

	if !hasmapto('<Plug>GBFbib')
		imap <buffer> <unique> <LocalLeader>b <Plug>GBFbib<ESC>kkkkk0f"a
	endif
	inoremap <buffer> <unique> <Plug>GBFbib <bib id=""><CR><TAB><tt></tt><CR><TAB><author></author><CR><TAB><editor></editor><CR><TAB><otherbib></otherbib><CR></bib>

	if !hasmapto('<Plug>GBFcitebib')
		imap <buffer> <unique> <LocalLeader>ci <Plug>GBFcitebib<ESC>hhi
	endif
	inoremap <buffer> <unique> <Plug>GBFcitebib <citebib id=""/>

	if !hasmapto('<Plug>GBFrb')
		imap <buffer> <unique> <LocalLeader>rb <Plug>GBFrb<ESC>F"la
	endif
	inoremap <buffer> <unique> <Plug>GBFrb <rb xml:lang="es"><rf></rf></rb>

	if !hasmapto('<Plug>GBFt')
		imap <buffer> <unique> <LocalLeader>t <Plug>GBFt<ESC>hhhi
	endif
	inoremap <buffer> <unique> <Plug>GBFt <t xml:lang="es"></t>

	if !hasmapto('<Plug>GBFw3')
		imap <buffer> <unique> <LocalLeader>w3 <Plug>GBFw3<ESC>F,i
	endif
	inoremap <buffer> <unique> <Plug>GBFw3 <wi type="G" value="3588,,"/>

	if !hasmapto('<Plug>GBFw2')
		imap <buffer> <unique> <LocalLeader>w2 <Plug>GBFw2<ESC>F,i
	endif
	inoremap <buffer> <unique> <Plug>GBFw2 <wi type="G" value="2532,,"/>

	if !hasmapto('<Plug>GBFw1')
		imap <buffer> <unique> <LocalLeader>w1 <Plug>GBFw1<ESC>F,i
	endif
	inoremap <buffer> <unique> <Plug>GBFw1 <wi type="G" value="1161,,"/>


	if !hasmapto('<Plug>GBFwi')
		imap <buffer> <unique> <LocalLeader>wi <Plug>GBFwi<ESC>bbbbla
	endif
	inoremap <buffer> <unique> <Plug>GBFwi <wi type="G" value=","><ESC>ea</wi>


endif
