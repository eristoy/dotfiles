"Eric's vimrc file


"Basic stuff
let s:colorful_term = (&term =~ "xterm") || (&term =~"screen")
let g:erlangHighlightBif = 1
let g:erlangHighLightOperators = 1
set nocompatible
set noexrc
"set background=dark
set fenc=utf-8
set cpoptions=aABceFsmq
syntax on
colorscheme vividchalk
set number
set title
let g:skip_loading_mswin=1

set history=9999
set timeoutlen=300
set formatoptions+=n
set formatlistpat=^\\s*\\(\\d\\\|[-*]\\)\\+[\\]:.)}\\t\ ]\\s*
set viminfo+=!
set nomore

"General
filetype plugin indent on

set backspace=indent,eol,start
set backup
set backupdir=~/.vim/backup
set directory=~/.vim/tmp
set fileformats=unix,dos,mac
set hidden
set iskeyword+=_,$,@,%,#
set noerrorbells
set whichwrap=b,s,h,l,<,>,~,[,]
" everything wraps
"             | | | | | | | | |
"             | | | | | | | | +-- "]" Insert and Replace
"             | | | | | | | +-- "[" Insert and Replace
"             | | | | | | +-- "~" Normal
"             | | | | | +-- <Right> Normal and Visual
"             | | | | +-- <Left> Normal and Visual
"             | | | +-- "l" Normal and Visual (not recommended)
"             | | +-- "h" Normal and Visual (not recommended)
"             | +-- <Space> Normal and Visual
"             +-- <BS> Normal and Visual
set wildmenu
set wildignore=*.dll,*.o,*.obj,*.bak,*.exe,*.pyc,*.jpg,*.gif,*.png
set wildmode=list:longest

"Vim UI
set incsearch
set laststatus=2
set lazyredraw
set list
"#set listchars=eol:$,tab:>-,space:25B8,trail:~,extends:>,precedes:<
set listchars=eol:⏎,tab:␉·,trail:␠,nbsp:⎵,extends:>,precedes:<
",space:▸
set matchtime=5
set report=0
set ruler
set scrolloff=10
set shortmess=aOstT
set showcmd
set showmatch
set sidescrolloff=10
set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
"              | | | | |  |   |      |  |     |    |
"              | | | | |  |   |      |  |     |    + current column
"              | | | | |  |   |      |  |     +-- current line
"              | | | | |  |   |      |  +-- current % into file
"              | | | | |  |   |      +-- current syntax in square brackets
"              | | | | |  |   +-- current fileformat
"              | | | | |  +-- number of lines
"              | | | | +-- preview flag in square brackets
"              | | | +-- help flag in square brackets
"              | | +-- readonly flag in square brackets
"              | +-- rodified flag in square brackets
"              +-- full path to file in the buffer
set completeopt=menuone
"========Tab settings
set tabstop=4
set shiftwidth=4
set expandtab
set shiftround
set smarttab

set formatoptions=rq
set ignorecase
set infercase
set nowrap
set smartcase

"Folding
set foldenable
set foldmethod=indent
set foldlevel=100
set foldopen=block,hor,mark,percent,quickfix,tag
function SimpleFoldText() " {
        return getline(v:foldstart).' '
endfunction " }
set foldtext=SimpleFoldText()

"Plugins

let perl_extended_vars=1
let tlist_php_settings = 'php;c:class;d:constant;f:function'

"Mappings

set pastetoggle=<F2>
noremap <S-space> <C-b>
noremap <space> <C-f>
nmap <C-N><C-N> :set invnumber<CR>
nmap <C-L><C-L> :set list<CR>
nmap <C-K><C-K> :set nolist<CR>
"Autocmds
autocmd BufNewFile *.html,*.htm,*.php source ~/.vim/ftplugin/htmltemplate.vim
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif
"====[ Show when lines extend past column 80 ]=================================>-<=====================

highlight ColorColumn ctermfg=208 ctermbg=Black

function! MarkMargin (on)
    if exists('b:MarkMargin')
        try
            call matchdelete(b:MarkMargin)
        catch /./
        endtry
        unlet b:MarkMargin
    endif
    if a:on
        let b:MarkMargin = matchadd('ColorColumn', '\%81v\s*\S', 100)
    endif
endfunction

augroup MarkMargin
    autocmd!
    autocmd  BufEnter  *       :call MarkMargin(1)
    autocmd  BufEnter  *.vp*   :call MarkMargin(0)
augroup END
