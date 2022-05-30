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
nmap <Leader>T :TagbarOpen fj<CR>


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

" Settings for python-mode
" cd ~/.vim/bundle
" git clone https://github.com/klen/python-mode
" map <Leader>g :call RopeGotoDefinition()<CR>
let ropevim_enable_shortcuts = 1
let g:pymode = 0 "disable pymode
let g:pymode_python = 'python3'
let g:pymode_doc = 0 "we use jedi instead
let g:pymode_rope_completion = 0   "we use jedi instead
let g:pymode_rope_goto_def_newwin = "new"
let g:pymode_rope_extended_complete = 1
let g:pymode_rope_complete_on_dot = 0
let g:pymode_breakpoint = 0
let g:pymode_syntax = 1
let g:pymode_syntax_builtin_objs = 0
let g:pymode_syntax_builtin_funcs = 0
" Skip errors and warnings
" E.g. "E501,W002", "E2,W" (Skip all Warnings and Errors startswith E2) and etc
let g:pymode_lint_checkers = ['pyflakes']
let g:pymode_lint_checker = 'pylint'
" let g:pymode_lint_ignore = "C0103,C0111,E1101,W0141,W0142,W0221,W0232,W0401,W0613,W0631"
let g:pymode_lint_ignore = "R0201,R0922,C0111,E1103,C0301,C0302,C0321,C0322,C0323,C0324,R0201,R0901,R0902,R0903,R0904,R0912,R0913,R0914,R0915,R0922,R0923,C0103,C0111,E1101,W0141,W0142,W0221,W0232,W0401,W0613,W0631"
let g:pymode_virtualenv = 1

" Load show documentation plugin
let g:pymode_doc = 1

" Key for show python documentation
let g:pymode_doc_key = 'K'

" Load run code plugin
let g:pymode_run = 1

" Key for run python code
let g:pymode_run_key = '<leader>r'

" Enable python objects and motion
let g:pymode_motion = 1

let g:pymode_syntax_space_errors = 0






set statusline+=%{tagbar#currenttag('%s','-','f')}
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_check_on_open = 1
let g:syntastic_python_python_exec = "python3"
let g:syntastic_python_checkers = ['python', 'pylint']
let g:syntastic_python_flake8_args = "--ignore=E501,E225 --max-complexity 10"
let g:syntastic_javascript_checkers = ['jshint']
let g:syntastic_error_symbol = "E>"
let g:syntastic_warning_symbol = "W>"
let g:syntastic_auto_jump = 0
let g:syntastic_loc_list_height = 5

set noshowmode
let g:jedi#use_tabs_not_buffers = 0
let g:jedi#popup_on_dot = 0
let g:jedi#goto_command = "<leader>d"
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = "<leader>G"
let g:jedi#show_call_signatures = 0
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>u"
let g:jedi#completions_command = "<leader>q"
let g:jedi#rename_command = "<leader>r"

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


map <leader>E <esc>:bufdo e<CR>
map <leader>r :resize<CR>
map <leader>X :SyntasticToggleMode<CR>

map <leader>n :NERDTreeToggle<CR>
" map <leader>m :Tlist<CR>
" map <leader>o :OpenSession
" Easier linewise reselection
nnoremap <leader>V V`]

onoremap ir i[
onoremap ar a[
vnoremap ir i[
vnoremap ar a[

" nmap <leader>a <Esc>:Ack!

" Better navigating through omnicomplete option list
" See http://stackoverflow.com/questions/2170023/how-to-map-keys-for-popup-menu-in-vim
set completeopt=longest,menuone
function! OmniPopup(action)
    if pumvisible()
         if a:action == 'j'
             return "\<C-N>"
         elseif a:action == 'k'
             return "\<C-P>"
         endif
     endif
     return a:action
endfunction

inoremap <silent><C-j> <C-R>=OmniPopup('j')<CR>
inoremap <silent><C-k> <C-R>=OmniPopup('k')<CR>

" let g:sparkupExecuteMapping = <C-e>

" Python folding
" mkdir -p ~/.vim/ftplugin
" wget -O ~/.vim/ftplugin/python_editing.vim http://www.vim.org/scripts/download_script.php?src_id=5492
set nofoldenable



let g:Tex_SmartKeyQuote = 0

au BufRead *.tex set textwidth=79 formatoptions=cqt wrapmargin=0


function! s:MakeWhite()
    set background=light
    colorscheme lucius
endfunction

function! s:MakeDark()
    set background=dark
    colorscheme wombat256mod
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


let g:qs_enable = 0

map <ESC>[4    <End>
map <ESC>[1    <Home>
imap <ESC>[4    <End>
imap <ESC>[1    <Home>

map <ESC>[4~    <End>
map <ESC>[1~    <Home>
imap <ESC>[4~    <End>
imap <ESC>[1~    <Home>

" source /home/proycon/.vim/bundle/vim-ipython/ftplugin/python/ipy.vim
