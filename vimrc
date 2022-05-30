" Automatic reloading of .vimrc
autocmd! bufwritepost .vimrc source %

set clipboard=unnamed
set hidden " allow leaving buffers without saving


let mapleader=" "


nmap L <esc>:bp<CR>
nmap H <esc>:bn<CR>

nnoremap <Leader>d "_d
xnoremap <Leader>d "_d

" bind Ctrl+<movement> keys to move around the windows, instead of using Ctrl+w + <movement>
" Every unnecessary keystroke that can be saved is good for your health :)
map <C-l> <c-w>l
map <C-h> <c-w>h
map <C-j> <c-w>j
map <C-k> <c-w>k


map <Leader>f <esc>:CtrlP<Cr>
map <Leader>b <esc>:CtrlPBuffer<CR>

"custom copy'n'paste
"
"copy the current visual selection to ~/.vbuf
vmap <Leader>y :w! ~/.vbuf<CR>:!xsel -i -b < ~/.vbuf<CR>
"copy the current line to the buffer file if no visual selection
nmap <Leader>y :.w! ~/.vbuf<CR>:!xsel -i -b < ~/.vbuf<CR>
"paste the contents of the buffer file
nmap <Leader>p :r ~/.vbuf<CR>
nmap <Leader>P :-1r ~/.vbuf<CR>


if filereadable($HOME . "/.light")
    set background=light
    colorscheme lucius
else
    set t_Co=256
    color gruvbox
    set background=dark
endif


" Showing line numbers and length
set number  " show line numbers
set textwidth=79   " width of document (used by gd)
" set nowrap  " don't automatically wrap on load
set fo-=t   " don't automatically wrap text when typing
" set colorcolumn=80
" highlight ColorColumn ctermbg=233
set cursorline "highlight current line
set wrap

" easier moving of code blocks
" Try to go into visual mode (v), thenselect several lines of code here and
" then press ``>`` several times.
vnoremap < <gv  " better indentation
vnoremap > >gv  " better indentation

" Useful settings
set history=700
set undolevels=700

" Use spaces by default
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab

" Make search case insensitive
set hlsearch
set incsearch
set ignorecase
set smartcase

set switchbuf=useopen,usetab
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮

" Disable stupid backup and swap files - they trigger too many events
" for file system watchers
set nobackup
set nowritebackup
set noswapfile


" Pathogen load
filetype off

call pathogen#infect()
call pathogen#helptags()

filetype plugin indent on
au! BufNewFile,BufRead *.ttl,*.nt,*.nq  set filetype=turtle
au! BufNewFile,BufRead *.n3 set filetype=n3
syntax on

autocmd FileType python,c,cpp,java,javascript,perl,awk,bash,haskell syn match ops /[(){}\[\]=\+\-%!\*:\,\.<>\|\&]/ | hi ops ctermfg=117



nmap <Leader>T :TagbarToggle<CR>


set ssop-=options    " do not store global and local values in a session
" set ssop-=folds      " do not store folds
set sessionoptions-=tabpages
set sessionoptions-=winsize
set sessionoptions-=winpos
set sessionoptions-=help
set sessionoptions+=resize,buffers,blank,curdir
let g:session_default_to_last="yes"
let g:session_autoload="yes"


" Settings for ctrlp
let g:ctrlp_max_height = 30
let g:ctrlp_extensions = ['funky']
" ignore .git folders to speed up searches
" let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
set wildignore+=*.pyc
set wildignore+=*.bak,*~,*.swp,*.lock
set wildignore+=*.o,*.lo,*.ko,*.so
set wildignore+=*.git/*
set wildignore+=*.svn/*
set wildignore+=*_build/*
set wildignore+=*build/*
set wildignore+=*coverage/*
set wildignore+=*.egg
set wildignore+=*.egg-info
set wildignore+=*.jpg,*.png,*.gif
set wildignore+=*.pdf,*.ps,*.aux,*.bbl,*.docx,*.doc,*.ppt,*.pptx,*.rtf
set wildignore+=*.mp3,*.ogg,*.mpg,*.mp4,*.wav,*.mov
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn)|build|dist)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ }


set statusline+=%{tagbar#currenttag('%s','-','f')}
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

set noshowmode

let g:airline_powerline_fonts = 1
let g:airline_theme = 'powerlineish'
let g:airline#extensions#bufferline#enabled = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:bufferline_echo = 1

map <leader>_ :%s=\s\+$==<CR>


map <leader>v :vsplit<CR>
map <leader>H :split<CR>
map <leader>w :w<CR>
map <leader>1 :b1<CR>
map <leader>2 :b2<CR>
map <leader>3 :b3<CR>
map <leader>4 :b4<CR>
map <leader>5 :b5<CR>
map <leader>6 :b6<CR>
map <leader>7 :b7<CR>
map <leader>8 :b8<CR>
map <leader>9 :b9<CR>
 

nmap <leader>r :resize<CR>

" map <leader>m :Tlist<CR>
" map <leader>o :OpenSession
" Easier linewise reselection
nnoremap <leader>V V`]

onoremap ir i[
onoremap ar a[
vnoremap ir i[
vnoremap ar a[

set nofoldenable

au BufRead *.tex set textwidth=79 formatoptions=cqt wrapmargin=0


function! s:MakeWhite()
    set background=light
    colorscheme lucius
endfunction

function! s:MakeDark()
    set t_Co=256
    color gruvbox
    set background=dark
endfunction

command! Spen setlocal spell spelllang=en_gb
command! Spus setlocal spell spelllang=en_us
command! Spnl setlocal spell spelllang=nl
command! Spbr setlocal spell spelllang=pt_br
command! Sppt setlocal spell spelllang=pt
command! Spes setlocal spell spelllang=es
command! Spit setlocal spell spelllang=it
command! Spde setlocal spell spelllang=de
command! Spfr setlocal spell spelllang=fr


map <ESC>[4    <End>
map <ESC>[1    <Home>
imap <ESC>[4    <End>
imap <ESC>[1    <Home>

map <ESC>[4~    <End>
map <ESC>[1~    <Home>
imap <ESC>[4~    <End>
imap <ESC>[1~    <Home>

" source /home/proycon/.vim/bundle/vim-ipython/ftplugin/python/ipy.vim
