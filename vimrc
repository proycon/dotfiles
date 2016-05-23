scriptencoding utf-8
set encoding=utf-8

" Automatic reloading of .vimrc
autocmd! bufwritepost .vimrc source %

" Better copy & paste
" " When you want to paste large blocks of code into vim, press F2 before you
" " paste. At the bottom you should see ``-- INSERT (paste) --``.
"

set pastetoggle=<F2>
set clipboard=unnamed

set mouse=a  " on OSX press ALT and click
set bs=2     " make backspace behave like normal again

" set term=screen-256color

set hidden " allow leaving buffers without saving
nnoremap <F9> :buffers<CR>:buffer<Space>


let mapleader=","
noremap \ ,

" for mutt only:
au BufRead /tmp/mutt-* set tw=72
au BufRead /tmp/mutt-* setlocal fo+=aw

" Quicksave command
"" noremap <C-Z> :update<CR>
"" vnoremap <C-Z> <C-C>:update<CR>
"" inoremap <C-Z> <C-O>:update<CR>


" Quick quit command
"" noremap <Leader>e :quit<CR>  " Quit current window
"" noremap <Leader>E :qa!<CR>   " Quit all windows

map <Leader>j <c-w>j
map <Leader>k <c-w>k
map <Leader>l <c-w>l
map <Leader>h <c-w>h


nnoremap <Leader>d "_d
xnoremap <Leader>d "_d

" easier moving between tabs
map <Leader>< <esc>:tabprevious<CR>
map <Leader>, <esc>:tabnext<CR>
map <Leader>= <esc>:bn<CR>
map <Leader>- <esc>:bp<CR>


" bind Ctrl+<movement> keys to move around the windows, instead of using Ctrl+w + <movement>
" Every unnecessary keystroke that can be saved is good for your health :)
map <C-l> <c-w>l
map <C-h> <c-w>h


map <C-m> <esc>:CtrlPFunky<Cr>
map <C-n> <esc>:CtrlPMRU<Cr>
map <C-b> <esc>:CtrlPBuffer<Cr>

" close quickfix window
" map <leader>E <esc>:ccl<CR>
" open
map <Leader>e <esc>:cw<CR> 


map <Leader>O <esc>:on<CR>
"map <Leader>P <esc>:hide<CR>
map <Leader>b <esc>:buffers<CR>:b 
map <Leader>B <esc>:MiniBufExplorer<CR>

"custom copy'n'paste
"
"copy the current visual selection to ~/.vbuf
vmap <Leader>y :w! ~/.vbuf<CR>     
"copy the current line to the buffer file if no visual selection
nmap <Leader>y :.w! ~/.vbuf<CR>    
"paste the contents of the buffer file
nmap <Leader>p :r ~/.vbuf<CR>       
nmap <Leader>P :-1r ~/.vbuf<CR>       

command! Caj !scp proycon@applejack.science.ru.nl:~/.vbuf ~/
command! C2aj !scp ~/.vbuf proycon@applejack.science.ru.nl:~/
command! Cap !scp proycon@anaproy.nl:~/.vbuf ~/
command! C2ap !scp ~/.vbuf proycon@anaproy.nl:~/

vnoremap <Leader>s :sort<CR>

"mail signature
map <Leader>S :r ~/sru<CR>

set t_Co=256
color proycon


" Showing line numbers and length
set number  " show line numbers
set textwidth=79   " width of document (used by gd)
" set nowrap  " don't automatically wrap on load
set fo-=t   " don't automatically wrap text when typing
" set colorcolumn=80
" highlight ColorColumn ctermbg=233
set cursorline "highlight current line
set wrap


"transparent background
"hi NonText ctermfg=250 ctermbg=none 


" easier moving of code blocks
" Try to go into visual mode (v), thenselect several lines of code here and
" then press ``>`` several times.
vnoremap < <gv  " better indentation
vnoremap > >gv  " better indentation

" Useful settings
set history=700
set undolevels=700

" Real programmers don't use TABs but spaces
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
syntax on

autocmd FileType python,c,cpp,java,javascript,perl,awk,bash,haskell syn match ops /[(){}\[\]=\+\-%!\*:\,\.<>\|\&]/ | hi ops ctermfg=117


""""" Settings for NERDTree

let NERDTreeIgnore=['\~$', '^\.git', '^\.svn', '\.swp$', '\.DS_Store$','\.pyc$','\.jpg$','\.png$','\.gif$','\.bak$','\.o$','\.lo$','\.in$','\.so$','\.aux$','\.pdf$','\.bbl$','^build','^dist' ]
let NERDTreeShowHidden=0
" nmap <Leader>n :NERDTreeToggle<cr>



nmap <Leader>t :TagbarToggle<CR>
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


map <leader>ct :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

" map <leader>y y:e ~/clipboard<CR>P:w !pbcopy<CR><CR>:bdelete!<CR>
" map <leader>y :w! ~/clipboard<CR>!cpcopy<CR>


" " ============================================================================
" Python IDE Setup
" ============================================================================


" Settings for vim-powerline
" cd ~/.vim/bundle
" git clone git://github.com/Lokaltog/vim-powerline.git
set laststatus=2


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
let g:syntastic_python_python_exec = "/home/proycon/lamachine/bin/python3"
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
let g:jedi#completions_command = "<leader>x"
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
map <leader>10 :b10<CR>
map <leader>11 :b11<CR>
map <leader>12 :b12<CR>
map <leader>13 :b13<CR>
map <leader>14 :b14<CR>
map <leader>15 :b15<CR>
map <leader>16 :b16<CR>
map <leader>17 :b17<CR>
map <leader>18 :b18<CR>
map <leader>19 :b19<CR>
map <leader>20 :b20<CR>
map <leader>21 :b21<CR>
map <leader>22 :b22<CR>
map <leader>23 :b23<CR>
map <leader>24 :b24<CR>
map <leader>25 :b25<CR>
map <leader>26 :b26<CR>
map <leader>27 :b27<CR>
map <leader>28 :b28<CR>
map <leader>29 :b29<CR>
map <leader>30 :b30<CR>
map <leader>31 :b31<CR>
map <leader>32 :b32<CR>
map <leader>33 :b33<CR>
map <leader>34 :b34<CR>
map <leader>35 :b35<CR>
map <leader>36 :b36<CR>
map <leader>37 :b37<CR>
map <leader>38 :b38<CR>
map <leader>39 :b39<CR>
map <leader>40 :b30<CR>
map <leader>41 :b41<CR>
map <leader>42 :b42<CR>
map <leader>43 :b43<CR>
map <leader>44 :b44<CR>
map <leader>45 :b45<CR>
map <leader>46 :b46<CR>
map <leader>47 :b47<CR>
map <leader>48 :b48<CR>
map <leader>49 :b49<CR>
map <leader>50 :b50<CR>
map <leader>51 :b51<CR>
map <leader>52 :b52<CR>
map <leader>53 :b53<CR>
map <leader>54 :b54<CR>
map <leader>55 :b55<CR>
map <leader>56 :b56<CR>
map <leader>57 :b57<CR>
map <leader>58 :b58<CR>
map <leader>59 :b59<CR>


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


 


fun! PullAndRefresh()
  set noconfirm
  !git pull
  bufdo e!
  set confirm
endfun

" nmap <leader>gr call PullAndRefresh()
function! s:MakeWhite()
    set background=light
    colorscheme lucius
endfunction

function! s:MakeDark()
    set background=dark
    colorscheme wombat256mod
endfunction

command! White call s:MakeWhite()
command! Dark call s:MakeDark()
command! W w
command! P2 let g:pymode_lint_checker = 'pylint'
command! P3 let g:pymode_lint_checker = 'pylint3'
command! UP call PullAndRefresh()

command! Spen setlocal spell spelllang=en_gb
command! Spus setlocal spell spelllang=en_us
command! Spnl setlocal spell spelllang=nl
command! Spbr setlocal spell spelllang=pt_br
command! Sppt setlocal spell spelllang=pt
command! Spes setlocal spell spelllang=es
command! Spit setlocal spell spelllang=it
command! Spde setlocal spell spelllang=de
command! Spfr setlocal spell spelllang=fr

" Insert into your .vimrc after quick-scope is loaded.
" Obviously depends on <https://github.com/unblevable/quick-scope> being installed.

function! Quick_scope_selective(movement)
    let needs_disabling = 0
    if !g:qs_enable
        QuickScopeToggle
        redraw
        let needs_disabling = 1
    endif

    let letter = nr2char(getchar())

    if needs_disabling
        QuickScopeToggle
    endif

    return a:movement . letter
endfunction

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
