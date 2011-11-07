set nocompatible
let vimhome = expand("<sfile>:h")
let vimpath = vimhome . "/.vim"
let vundledir = vimpath . "/bundle"
let vundledir = expand(vundledir)
exec("set rtp+=" . vimpath)
exec("set rtp+=" . vimpath . "/bundle/vundle/")
call vundle#rc(vundledir)
exec("source " . vimpath . "/bundle.vim")
exec("source " . vimpath . "/statusline.vim")
exec("source " . vimpath . "/autocommands.vim")
"editor specificvalue
set grepprg=ack
set ttyfast
set lazyredraw
set scrolljump=5
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
set completeopt=longest,menu,preview
set laststatus=2
set undofile
set mouse=a
set showmatch
set matchtime=2
set nonumber
set showcmd
set relativenumber
syntax enable
set t_Co=256
colorscheme xoria256
set fdm=manual
set synmaxcol=200
set ttyscroll=3
"""
"gui
if has('gui_running')
    set guioptions-=T  " no toolbar
    set guifont=Monaco:h9
    let g:indent_guides_enable_on_vim_startup = 1
    set list
    set listchars=tab:▸\ ,eol:¬
    set background=dark
    colorscheme molokai
endif
"""
"file handling
set undolevels=1000
set updatecount=100
set backup
set undofile
set undolevels=512
exec("set undodir=" . vimpath . "/undo")
exec("set backupdir=" . vimpath . "/backup")
exec("set directory=" . vimpath . "/tmp")
"""
"editting
set backspace=indent,eol,start
set cindent
set smartindent
set autoindent
set expandtab tabstop=4 shiftwidth=4 softtabstop=4
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
"set tags=tags;/
"set tags+=../tags,../../tags,../../../tags,../../../../tags
"let Tlist_Ctags_Cmd = "/usr/bin/ctags"
let g:syntastic_enable_signs=1
let g:syntastic_auto_jump=1
"let g:syntastic_auto_loc_list=1
filetype plugin indent on
exec("source " . vimpath . "/mappings.vim")
