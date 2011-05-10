set nocompatible
set rtp+=~/.vim/vundle.git/
call vundle#rc()
source $HOME/.vim/bundle.vim
source $HOME/.vim/statusline.vim
source $HOME/.vim/autocommands.vim
let g:is_posix = 1
"editor specificvalue
set clipboard+=unnamed
set pastetoggle=<F10>
set modeline
set modelines=5
set autoread
set autowrite
set cmdheight=2
set timeoutlen=1200
set ttimeoutlen=50
set laststatus=2
set ttyfast
set lazyredraw
set visualbell
set hidden
set history=1000
set undolevels=1000
set noerrorbells
set laststatus=2
set title
set encoding=utf-8
set showmode
set wildmenu
set wildmode=list:longest
set colorcolumn=80
set list
set listchars=tab:▸\ ,eol:¬
set completeopt=longest,menu,preview
set laststatus=2
set undofile
set mouse=a
set showmatch
set matchtime=2
set nonumber
set relativenumber
syntax enable
"""
"gui
if has('gui_running')
  set guioptions-=T  " no toolbar
  set guifont=monofur\ 10.5
  set background=dark
  colorscheme molokai
endif
"""
"file handling
set undolevels=1000
set updatecount=100
set backup
set backupdir=~/.backup
set undofile
set undodir=~/.undo
set undolevels=512
set directory=/tmp
"""
"editting
set backspace=indent,eol,start
set cindent
set smartindent
set autoindent
set expandtab tabstop=4 shiftwidth=4 softtabstop=4
let g:indent_guides_enable_on_vim_startup = 1
set fo+=o " Automatically insert the current comment leader after hitting 'o' or 'O' in Normal mode.
set fo-=r " Do not automatically insert a comment leader after an enter
set fo-=t " Do no auto-wrap text using textwidth (does not apply to comments)
"""
"search
set matchtime=5
set ignorecase
set smartcase
set hlsearch
set incsearch
"""
"addon specific
let php_sql_query=1
let php_htmlInStrings=1
set tags=tags;/
set tags+=../tags,../../tags,../../../tags,../../../../tags
let Tlist_Ctags_Cmd = "/usr/bin/ctags"
let g:bufExplorerSortBy = "name"
filetype plugin indent on
set tags+=~/.vim/ctags/riskiq
source $HOME/.vim/mappings.vim
