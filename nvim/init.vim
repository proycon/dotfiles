" init.vim (c) monedasperdidas 2016 , proycon 2017+

" vim-plug autoconfig if not already installed
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | nested source $MYVIMRC
endif

" startup for vim-plug
call plug#begin('~/.config/nvim/plugged')

" Completions using deoplete (disabled)
"if has('nvim')
"  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } "autocompletion
"else "vim8
"  Plug 'Shougo/deoplete.nvim'
"  Plug 'roxma/nvim-yarp'
"  Plug 'roxma/vim-hug-neovim-rpc'
"endif
"Plug 'zchee/deoplete-jedi', { 'for': 'python' } "deoplete completion for python (through jedi)
"Plug 'davidhalter/jedi-vim', { 'for': 'python' } "we will only use part of it, completions are already handled by deoplete-jedi
"Plug 'Shougo/neco-vim', { 'for': 'vim' } "provides deoplete completion for vim commands
"Plug 'sebastianmarkow/deoplete-rust', { 'for': 'rust' } "deoplete completion for rust
"Plug 'lvht/phpcd.vim', { 'for': 'php', 'do': 'composer install' }
"Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' } "deoplete completion for javascript
"Plug 'Shougo/deoplete-clangx' "deoplete completion for C++
"Plug 'Shougo/neoinclude.vim' "Include completion framework for neocomplete/deoplete
"
"
"
"Completions and more using Coc
if has('nvim')
    Plug 'neoclide/coc.nvim', {'tag': '*', 'do': './install.sh'}
    Plug 'neoclide/coc-python', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-eslint', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-rls', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-css', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-html', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-yaml', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-vimtex', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-vetur', {'do': 'yarn install --frozen-lockfile'} "for Vue.js
    Plug 'danielwelch/coc-homeassistant', {'do': 'yarn install --frozen-lockfile'}
endif

"
" Snippets
Plug 'Shougo/neosnippet' | Plug 'Shougo/neosnippet-snippets' "snippets, depends on deoplete

" Helpers
"Plug 'Shougo/denite.nvim' "ctrl-p like behaviour
Plug 'Shougo/vimproc.vim', { 'do': 'make' } "asynchronous execution library for Vim
"Plug 'haya14busa/incsearch.vim'
Plug 'tpope/vim-surround' "change surround tags (cs'NEW)
Plug 'vim-scripts/matchit.zip'
Plug 'easymotion/vim-easymotion' "highlights possible movement choices
Plug 'airblade/vim-rooter' "open relative to git repo
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
"Plug 'kassio/neoterm'
"Plug 'edkolev/promptline.vim'
"Plug 'xolox/vim-misc' | Plug 'xolox/vim-session'
"Plug 'benmills/vimux' "vim/tmux integration
"Plug 'julienr/vim-cellmode' "sends codeblocks to ipython in tmux pane
Plug 'jeetsukumaran/vim-markology' "mark visualisation/navigation/management
Plug 'frioux/vim-lost' "provides a :Lost command to find where you are
Plug 'skywind3000/asyncrun.vim' "Run shell commands asynchronously


" IDE
Plug 'scrooloose/nerdtree', { 'on':  ['NERDTreeToggle', 'NERDTree'] }
"Plug 'neomake/neomake' "Asynchronous linting and make framework for Neovim/Vim
Plug 'tpope/vim-fugitive'
"Plug 'tpope/rhubarb'
"Plug 'gregsexton/gitv' "gitk for vim
Plug 'vim-scripts/gitignore'
Plug 'majutsushi/tagbar' "tag (class/function) browser
Plug 'vim-scripts/indentpython.vim'
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
"Plug 'tmhedberg/SimpylFold' "folding for python
Plug 'Konfekt/FastFold'
Plug 'airblade/vim-gitgutter' "git diff in gutter
Plug 'lervag/vimtex'
Plug 'nathanaelkane/vim-indent-guides', { 'for': 'python' }
Plug 'rust-lang/rust.vim' "for Rust
"Plug 'racer-rust/vim-racer' "(disabled in favour of coc-rls)
Plug 'cespare/vim-toml' "for toml files
Plug 'posva/vim-vue' "for vue.js
Plug 'leafgarland/typescript-vim' "Typescript syntax highlighting (and more?)
Plug 'fatih/vim-go' "Go
Plug 'szymonmaszke/vimpyter' "vim-plug

" Misc
Plug 'junegunn/goyo.vim' "distraction free writing
Plug 'miyakogi/seiya.vim' "transparent background
Plug 'tpope/vim-characterize' "unicode information on 'ga' character inspection

" Syntax helpers
Plug 'pearofducks/ansible-vim' "highlighting for ansible
Plug 'freitass/todo.txt-vim', { 'for': 'todo.txt' }
Plug 'plasticboy/vim-markdown'
Plug 'chrisbra/csv.vim'


"Themes
Plug 'morhetz/gruvbox'

"On-the-fly GnuPG
Plug 'jamessan/vim-gnupg'

call plug#end()

let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'

set clipboard+=unnamedplus
set completeopt-=preview
set noshowmode
set lazyredraw
set hidden
set ruler
set ignorecase
set smartcase
set magic
set noshowmatch
set nobackup
set nowb
set noswapfile
set noerrorbells
set expandtab
set updatetime=250
set cursorline

set nofoldenable "don't automatically fold stuff

set tabstop=4
set softtabstop=4
set shiftwidth=4

set number
set numberwidth=4
set fileformat=unix

set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮

set whichwrap+=<,>,h,l

let mapleader="\<Space>"
map , <leader>
noremap \ ,

map <Leader>. <esc>:bn<CR>
map <Leader>/ <esc>:bp<CR>
map <Leader>= <esc>:bn<CR>
map <Leader>- <esc>:bp<CR>
map <Leader>, <esc>:e#<CR>
map <Leader>x <esc>:bd<CR>
map <Leader><Space> <esc>:e#<CR>

map <Leader>j <c-w>j
map <Leader>k <c-w>k
map <Leader>l <c-w>l
map <Leader>h <c-w>h

map <leader>_ :%s=\s\+$==<CR>

map <leader>E <esc>:bufdo e<CR>

map <leader>v :vsplit<CR>
map <leader>H :split<CR>
map <leader>w :w<CR>
"map <leader>1 :b1<CR>
"map <leader>2 :b2<CR>
"map <leader>3 :b3<CR>
"map <leader>4 :b4<CR>
"map <leader>5 :b5<CR>
"map <leader>6 :b6<CR>
"map <leader>7 :b7<CR>
"map <leader>8 :b8<CR>
"map <leader>9 :b9<CR>
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
"nmap <leader>- <Plug>AirlineSelectPrevTab
"nmap <leader>+ <Plug>AirlineSelectNextTab


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

"
"custom copy'n'paste
"
"copy the current visual selection to ~/.vbuf
vmap <Leader>y :w! ~/.vbuf<CR>:!xsel -i -b < ~/.vbuf<CR>
"copy the current line to the buffer file if no visual selection
nmap <Leader>y :.w! ~/.vbuf<CR>:!xsel -i -b < ~/.vbuf<CR>
"paste the contents of the buffer file
nmap <Leader>p :r ~/.vbuf<CR>
nmap <Leader>P :-1r ~/.vbuf<CR>

command! Caj !scp proycon@applejack.science.ru.nl:~/.vbuf ~/
command! C2aj !scp ~/.vbuf proycon@applejack.science.ru.nl:~/
command! Cap !scp proycon@anaproy.nl:~/.vbuf ~/
command! C2ap !scp ~/.vbuf proycon@anaproy.nl:~/

vnoremap <Leader>s :sort<CR>

xnoremap < <gv
xnoremap > >gv

"mail signature
map <Leader>S :r ~/.signature.ru<CR>

command! Spen setlocal spell spelllang=en_gb
command! Spus setlocal spell spelllang=en_us
command! Spnl setlocal spell spelllang=nl
command! Spbr setlocal spell spelllang=pt_br
command! Sppt setlocal spell spelllang=pt
command! Spes setlocal spell spelllang=es
command! Spit setlocal spell spelllang=it
command! Spde setlocal spell spelllang=de
command! Spfr setlocal spell spelllang=fr

" wildignoresettings
set wildignore+=*.pyc
set wildignore+=*.gem
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

set formatoptions-=t   " don't automatically wrap text when typing
set formatoptions+=jq   " join comments if it makes sense, when joining lines, allow formatting of comments with gq


" python special settings
au BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 textwidth=120
au BufRead *.tex set textwidth=120 formatoptions=cqt wrapmargin=0
au BufRead *.txt,*.md,*.rst set textwidth=120 formatoptions+=t wrapmargin=0
au BufRead,BufNewFile */roles/*.yml set filetype=yaml.ansible
au BufRead,BufNewFile *.nginx set ft=nginx
au BufRead,BufNewFile */etc/nginx/* set ft=nginx
au BufRead,BufNewFile */nginx/conf/* set ft=nginx
au BufRead,BufNewFile nginx.conf set ft=nginx

nnoremap <silent> <A-right> :bn<CR>
nnoremap <silent> <A-left> :bp<CR>

" neovim terminal
tnoremap <Esc> <C-\><C-n>

" conceal markers
if has('conceal')
  set conceallevel=2
endif

" NERDTree things
let NERDTreeWinPos='left'
let NERDTreeQuitOnOpen=1
let NERDTreeMinimalUI=1
let NERDTreeRespectWildIgnore=1
map <Leader>f :NERDTreeToggle<CR>

" incsearch.vim
" #let g:incsearch#auto_nohlsearch = 1
" set hlsearch
" map /  <Plug>(incsearch-forward)
" map ?  <Plug>(incsearch-backward)
" map g/ <Plug>(incsearch-stay)
" map n  <Plug>(incsearch-nohl-n)
" map N  <Plug>(incsearch-nohl-N)
" map *  <Plug>(incsearch-nohl-*)
" map #  <Plug>(incsearch-nohl-#)
" map g* <Plug>(incsearch-nohl-g*)
" map g# <Plug>(incsearch-nohl-g#)
"
" urlview
:noremap <leader>U :w<Home>silent <End> !urlview<CR>
:noremap <leader>L :Lost<CR>

" TagBar
nmap <C-t> :TagbarToggle<CR>
nmap <Leader>t :TagbarToggle<CR>
nmap <Leader>T :TagbarOpen fj<CR>

" Buffer switching
nnoremap <F12> :buffers<CR>:buffer<Space>
map <esc>[1;0D <C-Left>
map <esc>[1;0C <C-Right>
map <C-Right> :bn<CR>
map <C-Left> :bp<CR>


" vim-airline settings
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#tabnr_formatter = 'tabnr'
"let g:airline#extensions#tabline#tabs_label = 't'
let g:airline#extensions#tabline#buffers_label = 'b'
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#formatter = 'default'
let g:airline#extensions#tabline#buffer_nr_show = 0
"let g:airline#extensions#tabline#fnametruncate = 16
"let g:airline#extensions#tabline#fnamecollapse = 2
let g:airline#extensions#tabline#buffer_idx_mode = 1 "adds the small numbers
let g:airline_theme = 'gruvbox'
let g:airline_powerline_fonts = 1
let g:airline#extensions#coc#enabled = 1

" themes and colors
let NVIM_TUI_ENABLE_CURSOR_SHAPE=1
set t_Co=256
if (!empty($TMUX))
    set termguicolors
endif
set background=dark
colorscheme gruvbox "proycon
let g:seiya_auto_enable=1
let g:seiya_target_groups = ['guibg']

" unite vim
let g:unite_source_grep_command = 'ack-grep'
let g:unite_source_grep_default_opts ='-i --no-heading --no-color -k -H'
let g:unite_source_grep_recursive_opt = ''

" fzf.vim
nnoremap <C-p> :GitFiles<cr>
nnoremap <C-f> :Files<cr>
nnoremap <C-b> :Buffers<cr>
nnoremap <C-n> :BLines<cr>
nnoremap <C-N> :Lines<cr>
nnoremap <C-g> :Commits<cr>
nnoremap <C-m> :Marks<cr>

nnoremap <leader>o :GitFiles<cr>
nnoremap <leader>O :Files<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>n :BLines<cr>
nnoremap <leader>N :Lines<cr>
nnoremap <leader>r :Tags<cr>

" session management
let g:session_autosave = 'no'


" deoplete + neosnippet + autopairs changes (DEOPLETE IS DISABLED!)
"let g:deoplete#auto_complete_start_length = 1
"let g:deoplete#enable_at_startup = 1
"let g:deoplete#enable_smart_case = 1
"let g:deoplete#sources#jedi#show_docstring = 1
"imap <expr><TAB> pumvisible() ? "\<C-n>" : (neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>")
"imap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
"imap <expr><CR> pumvisible() ? deoplete#mappings#close_popup() : "<CR>"
" Let <Tab> also do completion
"inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : deoplete#mappings#manual_complete()

"let g:deoplete#ignore_sources = get(g:, 'deoplete#ignore_sources', {})
"let g:deoplete#ignore_sources.php = ['omni']
"let g:deoplete#sources#ternjs#case_insensitive = 1
"Add extra filetypes for javascript
"let g:deoplete#sources#ternjs#filetypes = [ 'jsx', 'javascript.jsx',  'vue' ]

" JEDI IS NOT USED!
"let g:jedi#auto_vim_configuration = 0
"let g:jedi#goto_assignments_command = '<Leader>ga'  " dynamically done for ft=python.
"let g:jedi#goto_definitions_command = '<Leader>gd'  " dynamically done for ft=python.
"let g:jedi#use_tabs_not_buffers = 0  " current default is 1.
"let g:jedi#rename_command = '<Leader>gR'
"let g:jedi#usages_command = '<Leader>gu'
"let g:jedi#completions_enabled = 0 "deoplete handles this already
"let g:jedi#smart_auto_mappings = 1

" Unite/ref and pydoc are more useful.
"let g:jedi#documentation_command = '<Leader>_K'
"let g:jedi#auto_close_doc = 1

"Rust
"let g:deoplete#sources#rust#racer_binary = "/home/proycon/.cargo/bin/racer" "for deoplete-rust
"let g:deoplete#sources#rust#rust_source_path = "/home/proycon/rust/src"

"Rust (vim-racer) (NOT USED!)
"let g:racer_cmd = "/home/proycon/.cargo/bin/racer" "for vim-racer
"let g:racer_experimental_completer = 0
"au FileType rust nmap gd <Plug>(rust-def)
"au FileType rust nmap <leader>gd <Plug>(rust-def)
"au FileType rust nmap K <Plug>(rust-doc)
"
"i

" ----------- COC.NVIM ---------------
" don't give |ins-completion-menu| messages.
set shortmess+=c
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> <leader>C <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

"
" Use K to show documentation in preview window
nnoremap <silent> K :call CocAction('doHover')<CR>

" Map for do codeAction of current line
nmap <leader>ac <Plug>(coc-codeaction)

" Map for do codeAction of selected region, ex: `<leader>aap` for current paragraph
vmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Map for format selected region
vmap <leader>F  <Plug>(coc-format-selected)
nmap <leader>F  <Plug>(coc-format-selected)
"
" Map for rename current word
nmap <silent>rn <Plug>(coc-rename)

nmap <Leader>d :CocList diagnostics<CR>      " open location window

set cmdheight=2
" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
"nmap <leader>rn <Plug>(coc-rename)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Cyrillic in normal mode, map some minimal cyrillic so I don't have to switch
" keymaps:

nmap и i
nmap ы y
nmap ч c
nmap п p
nmap о o
nmap х h
nmap й j
nmap к k
nmap л l
nmap Ж :
nmap д d
nmap в v
nmap б b
nmap н n
nmap м m


"/----------- COC.NVIM ---------------

imap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

let g:neosnippet#snippets_directory = "/home/proycon/dotfiles/nvim/snippets"
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#expand_word_boundary = 1
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)


" neomake (DISABLED)
"nmap <Leader><Space>o :lopen<CR>      " open location window
"nmap <Leader><Space>c :lclose<CR>     " close location window
"nmap <Leader><Space>, :ll<CR>         " go to current error/warning
"nmap <Leader><Space>n :lnext<CR>      " next error/warning
"nmap <Leader><Space>p :lprev<CR>      " previous error/warning
" show quicklist with errors
"let g:neomake_open_list = 2

" bind Ctrl+<movement> keys to move around the windows, instead of using Ctrl+w + <movement>
" Every unnecessary keystroke that can be saved is good for your health :)
map <C-l> <c-w>l
map <C-h> <c-w>h

"markology (mark visualisation/navigation/management
let g:markology_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789."
let g:markology_ignore_type = "hmpq"
let g:markology_hlline_lower = 1
let g:markology_hlline_upper = 1
let g:markology_textlower = "\t"
highlight MarkologyHLl guifg=cyan guibg=black

" Indentguides (toggle with <leader>ig)
let g:indent_guides_auto_colors = 0
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2
hi IndentGuidesEven  guibg=#3a3a3a ctermbg=darkgrey
hi IndentGuidesOdd guibg=#1a1a1a ctermbg=black

" Markdown
let g:vim_markdown_math = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_toml_frontmatter = 1
let g:vim_markdown_json_frontmatter = 1
"autocmd Filetype markdown map <F5> :!pandoc<space><C-r>%<space>-o<space><C-r>%.pdf<Enter>zathura<space>&<Enter>
autocmd Filetype markdown map <F4> :!<space>export<space>F="<C-r>%"<space>&&<space>pandoc<space>-s<space>-f<space>gfm<space>-H<space>~/dotfiles/header.sty<space>-o<space>${F\%.md}.pdf<space><C-r>%<space>&&<space>DISPLAY=:0.0<space>zathura<space>${F\%.md}.pdf<Enter>
autocmd Filetype markdown map <F5> :AsyncRun<space>export<space>F="<C-r>%"<space>&&<space>pandoc<space>-s<space>-f<space>gfm<space>-H<space>~/dotfiles/header.sty<space>-o<space>${F\%.md}.pdf<space><C-r>%<space>&&<space>DISPLAY=:0.0<space>zathura<space>${F\%.md}.pdf<Enter>
autocmd Filetype markdown map <F6> :!<space>export<space>F="<C-r>%"<space>&&<space>pandoc<space>-s<space>-f<space>markdown<space>-H<space>~/dotfiles/header.sty<space>-o<space>${F\%.md}.pdf<space><C-r>%<space>&&<space>DISPLAY=:0.0<space>zathura<space>${F\%.md}.pdf<Enter>
autocmd Filetype tex map <F5> :AsyncRun<space>export<space>F="<C-r>%"<space>&&<space>pdflatex<space><C-r>%<space>&&<space>DISPLAY=:0.0<space>zathura<space>${F\%.tex}.pdf<Enter>
autocmd Filetype tex map <F4> :!export<space>F="<C-r>%"<space>&&<space>pdflatex<space><C-r>%<space>&&<space>DISPLAY=:0.0<space>zathura<space>${F\%.tex}.pdf<Enter>
autocmd Filetype python map <F4> :!cd $(git<space>rev-parse<space>--show-toplevel)<space>&&<space>pip<space>install<space>.<Enter>
autocmd Filetype python map <F5> :!cd $(git<space>rev-parse<space>--show-toplevel)<space>&&<space>pip<space>install<space>.<Enter>
map <F9> :Gcommit -a<CR>
map <F10> :Gpush<CR>

"ansible-vim
let g:ansible_name_highlight = 'b'
let g:ansible_extra_keywords_highlight = 1

"vimpyter
autocmd Filetype ipynb nmap <silent><Leader>b :VimpyterInsertPythonBlock<CR>
autocmd Filetype ipynb nmap <silent><Leader>j :VimpyterStartJupyter<CR>
autocmd Filetype ipynb nmap <silent><Leader>n :VimpyterStartNteract<CR>


augroup neovim
  autocmd!
  autocmd FileType vimfiler set nonumber | set norelativenumber
  autocmd Filetype * if &ft!='vimfiler' | set number | endif
  "autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
  autocmd StdinReadPre * let s:std_in=1
  autocmd BufWritePre * %s/\s\+$//e
  "autocmd BufWritePost * Neomake
  autocmd BufWritePost $MYVIMRC nested source $MYVIMRC
augroup END

" from http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
if executable('ag')
	set grepprg=ag\ --nogroup\ --nocolor
endif
if executable('rg') "pacman -Syu ripgrep
	set grepprg=rg\ --no-heading\ --vimgrep
	set grepformat=%f:%l:%c:%m
endif

noremap <silent><expr> <c-space> coc#refresh()



function! s:MakeWhite()
    set background=light
    colorscheme gruvbox
endfunction

function! s:MakeDark()
    set background=dark
    colorscheme gruvbox
endfunction

command! White call s:MakeWhite()
command! Dark call s:MakeDark()
command! W w

" Override cursorline color
hi CursorLine					ctermbg=236		cterm=none						guibg=#000000

" #do italics
set t_ZH=[3m
set t_ZR=[23m
highlight Comment cterm=italic

