" ~/.vim/sessions/clam.vim: Vim session script.
" Created by session.vim 1.5 on 07 April 2013 at 20:52:00.
" Open this file in Vim and run :source % to restore your session.

set guioptions=aegimrLtT
silent! set guifont=
if exists('g:syntax_on') != 1 | syntax on | endif
if exists('g:did_load_filetypes') != 1 | filetype on | endif
if exists('g:did_load_ftplugin') != 1 | filetype plugin on | endif
if exists('g:did_indent_on') != 1 | filetype indent on | endif
if &background != 'light'
	set background=light
endif
if !exists('g:colors_name') || g:colors_name != 'wombat256mod' | colorscheme wombat256mod | endif
call setqflist([])
let SessionLoad = 1
if &cp | set nocp | endif
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd ~/work/clam
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +46 clamservice.py
badd +3 common/data.py
badd +0 common/client.py
args clamservice.py
set lines=49 columns=158
edit common/client.py
set splitbelow splitright
wincmd _ | wincmd |
vsplit
wincmd _ | wincmd |
vsplit
2wincmd h
wincmd w
wincmd w
set nosplitbelow
set nosplitright
wincmd t
set winheight=1 winwidth=1
exe 'vert 1resize ' . ((&columns * 31 + 79) / 158)
exe 'vert 2resize ' . ((&columns * 97 + 79) / 158)
exe 'vert 3resize ' . ((&columns * 28 + 79) / 158)
argglobal
enew
" file NERD_tree_1
wincmd w
argglobal
let s:l = 1 - ((0 * winheight(0) + 23) / 47)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
wincmd w
argglobal
enew
file __Tag_List__
wincmd w
2wincmd w
exe 'vert 1resize ' . ((&columns * 31 + 79) / 158)
exe 'vert 2resize ' . ((&columns * 97 + 79) / 158)
exe 'vert 3resize ' . ((&columns * 28 + 79) / 158)
tabnext 1
if exists('s:wipebuf')
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 shortmess=filnxtToO
let s:sx = expand("<sfile>:p:r")."x.vim"
if file_readable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save
doautoall SessionLoadPost
unlet SessionLoad
tabnext 1
1wincmd w
let s:bufnr = bufnr("%")
NERDTree ~/work/clam
execute "bwipeout" s:bufnr
1resize 47|vert 1resize 31|2resize 47|vert 2resize 97|3resize 47|vert 3resize 28|
tabnext 1
2wincmd w

" vim: ft=vim ro nowrap smc=128
