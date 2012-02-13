" turns off compatibility with old vi
set nocompatible
" configuring vim on first run
" Section: Startup{{{1
" --------------------
" Configures vim path to load files where the .vimrc is locate, it also checks
" if vim is running for first time and tries to set up plugins using gmarik's
" bundle plugin for vim.

" `vim_path` current .vim dir on script directory
let b:vim_path = expand("<sfile>:h") . "/.vim"
exe "set rtp+=" . b:vim_path
exe "set rtp+=" . b:vim_path . "/bundle/vundle/"
try
  call vundle#rc(expand(b:vim_path . "/bundle"))
catch
  try
    exe '!git clone https://github.com/gmarik/vundle.git ' . shellescape(b:vim_path . "/bundle/vundle/")
    source <sfile>
    exe "set rtp+=" . b:vim_path . "/bundle/vundle/"
    exe "BundleInstall"
  catch
    let b:has_bundle = 0;
  endtry
endtry
" Section: Options  {{{1
" ----------------------
"  Vim configurable Options
"


" editting
set autochdir          " Changes dir to current editing
set cindent            " ident with spaces
set smarttab           " Insert spaces when indenting with tab
set smartindent        " Smart ident depending on the language
set autoindent         " Autoindent on new line
" search
set hlsearch           " Highlights search
set incsearch          " Shows search matches as you type
set showmatch          " Shows matching Bracket, parenthesis, etc...
set smartcase          " Matchs uppercase on search
set matchtime=5        " Time to show matching Bracket
" other options
set undolevels=1000
set updatecount=100
set backup
exec("set undodir=" . b:vim_path . "/undo")
exec("set backupdir=" . b:vim_path . "/backup")
exec("set directory=" . b:vim_path . "/tmp")
filetype plugin indent on
set clipboard+=unnamed " Yanking to system clipboard
set ttyfast            " Faster drawing
set hidden             " Lets you send buffers to backgrund whitout saving them
set history=1000       " Size of history file
set undolevels=1000    " Size of undo history file
set noerrorbells       " No beeps on error
set title              " Set the title in GUI/screen mode
set encoding=utf-8     " Utf-8
set showmode           " Shows current mode under the status bar
set colorcolumn=80     " Show a column marker for standard 80 chars on coding
set mouse=a            " Enables mouse on all modes
syntax enable          " Syntax highlighting
set synmaxcol=400      " Disables highlighting on long lines for speed
set ttyscroll=3        " Faster redrawing
set autowrite          " Autowrite on some commands (make)
set backspace=2        " Makes backspace powerful
set splitbelow         " Split windows at bottom
set suffixes+=.dvi     " Lower priority in wildcards
set timeoutlen=1200    " A little bit more time for macros
set ttimeoutlen=50     " Make Esc work faster
set mousemodel=popup   " Right click popups a menu
set scrolloff=1        " Minimum number of lines to show up/dow of current line
set showcmd            " Show commands as you type them
set complete-=i        " Smart complete
set laststatus=2       " Always show  status lines
set lazyredraw         " no redraw on macros execution
set grepprg=ack        " Ack is more powerful
set visualbell         " Screen titles on error
set wildmenu           " enhanced completion on command line
set winaltkeys=no      " Disables alt for showing the app menu
set virtualedit=block  " Lets you select on visual mode past the line
set fileformats=unix,dos,mac    " Fileformat according to file
set backupskip+=*.tmp,crontab.* " Don't backup those files
set wildmode=longest:full,full  " All options to command line completion
set wildignore+=*~,*.aux,tags,*/.git/*,*/.hg/*,*/.svn/* " ignore those files

if exists("&breakindent")
  set breakindent showbreak=+++
elseif has("gui_running")
  set showbreak=\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ +++
endif
if has("eval")
  let &fileencodings = substitute(&fileencodings,"latin1","cp1252","")
  let &highlight = substitute(&highlight,'NonText','SpecialKey','g')
endif
if (&termencoding ==# 'utf-8' || &encoding ==# 'utf-8') && version >= 700
  let &listchars = "tab:\u21e5\u00b7,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u26ad"
else
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<
endif
if exists("+spelllang")
  set spelllang=en_us
endif
if exists('+undofile')
  set undofile
endif
if v:version >= 700
  set viminfo=!,'20,<50,s10,h
endif
if v:version >= 600
  set autoread
  set foldmethod=marker
  set printoptions=paper:letter
  set sidescrolloff=5
  set mouse=nvi
endif

if v:version < 602 || $DISPLAY =~ '^localhost:' || $DISPLAY == ''
  set clipboard-=exclude:cons\\\|linux
  set clipboard+=exclude:cons\\\|linux\\\|screen.*
  if $TERM =~ '^screen'
    set mouse=
    colorscheme solarized
  endif
endif

if !has("gui_running") && $DISPLAY == '' || !has("gui")
  set mouse=
endif

if $TERM =~ '^screen'
  if exists("+ttymouse") && &ttymouse == ''
    set ttymouse=xterm
  endif
  if $TERM == 'screen-bce' && &t_Co == 8
    set t_Co=256
  endif
  if $TERM != 'screen.linux' && &t_Co == 8
    set t_Co=256
  endif
endif

if $TERM == 'xterm-color' && &t_Co == 8
  set t_Co=16
endif

if has("dos16") || has("dos32") || has("win32") || has("win64")
  if $PATH =~? 'cygwin' && ! exists("g:no_cygwin_shell")
    set shell=bash
    set shellpipe=2>&1\|tee
    set shellslash
  endif
elseif has("mac")
  set backupskip+=/private/tmp/*
endif

" Section: Commands {{{1
" -----------------------
" Commands for vim command Line
"

" `:SudoW`      prompts sudo to write a file  if vim is not executed as sudo
command! -bar -nargs=0 SudoW :setl nomod|silent exe 'write !sudo tee % >/dev/null'|let &mod = v:shell_error
" `:W`          fixes W typo
command! -bar -nargs=* -bang W :write<bang> <args>
" `:Scratch`    opens a scratch buffer
command! -bar -nargs=0 -bang Scratch :silent edit<bang> \[Scratch]|set buftype=nofile bufhidden=hide noswapfile buflisted
" `:RFC Number` opens the specified RFC number
command! -bar -count=0 RFC :e http://www.ietf.org/rfc/rfc<count>.txt|setl ro noma
" `:Rename xxx` renames current file to xxx
command! -bar -nargs=* -bang -complete=file Rename :
      \ let v:errmsg = ""|
      \ saveas<bang> <args>|
      \ if v:errmsg == ""|
      \ call delete(expand("#"))|
      \ endif
" `:Invert`     toggles the background dark/light
command! -bar Invert :let &background = (&background=="light"?"dark":"light")
" `:Fancy`      shows ruler and foldcolumn
function! Fancy()
  if &number
    if has("gui_running")
      let &columns=&columns-12
    endif
    windo set nonumber foldcolumn=0
    if exists("+cursorcolumn")
      set nocursorcolumn nocursorline
    endif
  else
    if has("gui_running")
      let &columns=&columns+12
    endif
    windo set number foldcolumn=4
    if exists("+cursorcolumn")
      set cursorline
    endif
  endif
endfunction
command! -bar Fancy :call Fancy()
" `:OpenURL string` opens string url in a browser
function! OpenURL(url)
  if has("win32") || has("win64")
    exe "!start cmd /cstart /b ".a:url.""
  elseif $DISPLAY !~ '^\w'
    exe "silent !sensible-browser \"".a:url."\""
  else
    exe "silent !sensible-browser -T \"".a:url."\""
  endif
  redraw!
endfunction
command! -nargs=1 OpenURL :call OpenURL(<q-args>)
" `gb` opens url/word under cursor on browser
nnoremap gb :OpenURL <cfile><CR>
" `gA` opens url/word under cursor on Answers dictionary
nnoremap gA :OpenURL http://www.answers.com/<cword><CR>
" `gG` opens url/word under cursor on google
nnoremap gG :OpenURL http://www.google.com/search?q=<cword><CR>
" `gW` opens url/word under cursor on wikipedia
nnoremap gW :OpenURL http://en.wikipedia.org/wiki/Special:Search?search=<cword><CR>


" Section: Mappings {{{1
" ----------------------
" ctrlp pluggin
nmap <silent> <leader>b :CtrlPBuffer<CR>
nmap <silent> <leader>u :CtrlPMRU<CR>
" -------
" Leader
let mapleader = ","
let maplocalleader = ","
" ------
nnoremap Q :<C-U>q<CR>
nnoremap Y y$
if exists(":hohls")
  nmap <silent> <leader>/ :nohls<CR>
endif
inoremap <C-C> <Esc>`^
nnoremap j gj
nnoremap k gk
inoremap jj <ESC>
" split the lines from cursor to the EOL, sending the second part to the line
" to the top of the current line
nnoremap zS r<CR>ddkP=j
" indents on paste
nnoremap =p m`=ap``
nnoremap == ==
vnoremap <M-<> <gv
vnoremap <M->> >gv
vnoremap <Space> I<Space><Esc>gv
" inserts comment at the current line with vim settings
" ex:
" " -*- vim -*- vim:set ft=vim et sw=2 sts=2:
inoremap <C-X>^ <C-R>=substitute(&commentstring,' \=%s\>'," -*- ".&ft." -*- vim:set ft=".&ft." ".(&et?"et":"noet")." sw=".&sw." sts=".&sts.':','')<CR>

" keys on insert mode and command mode
inoremap <M-h> <Left>
inoremap <M-l> <right>
inoremap <M-j> <up>
inoremap <M-k> <down>
cnoremap <M-h> <Left>
cnoremap <M-l> <right>
cnoremap <M-j> <up>
cnoremap <M-k> <down>
" ------------------
" Common motions on insert and command mode
inoremap <M-o> <C-O>o
inoremap <M-O> <C-O>O
inoremap <M-I> <C-O>^
inoremap <M-A> <C-O>$
inoremap <CR>  <C-G>u<CR>
" -----------------------------------------
"unmapping annoying keys
noremap! <C-J> <Down>
noremap! <C-K><C-K> <Up>
nnoremap <up>    <nop>
nnoremap <down>  <nop>
nnoremap <left>  <nop>
nnoremap <right> <nop>
inoremap <up>    <nop>
inoremap <down>  <nop>
inoremap <left>  <nop>
inoremap <right> <nop>
"-----------------------
if has("eval")
  command! -buffer -bar -range -nargs=? Slide :exe 'norm m`'|exe '<line1>,<line2>move'.((<q-args> < 0 ? <line1>-1 : <line2>)+(<q-args>=='' ? 1 : <q-args>))|exe 'norm ``'
endif
" If at end of a line of spaces, delete back to the previous line.
" Otherwise, <Left>
inoremap <silent> <C-B> <C-R>=getline('.')=~'^\s*$'&&col('.')>strlen(getline('.'))?"0\<Lt>C-D>\<Lt>Esc>kJs":"\<Lt>Left>"<CR>
cnoremap <C-B> <Left>
" If at end of line, decrease indent, else <Del>
inoremap <silent> <C-D> <C-R>=col('.')>strlen(getline('.'))?"\<Lt>C-D>":"\<Lt>Del>"<CR>
cnoremap <C-D> <Del>
" If at end of line, fix indent, else <Right>
inoremap <silent> <C-F> <C-R>=col('.')>strlen(getline('.'))?"\<Lt>C-F>":"\<Lt>Right>"<CR>
if !has("gui_running")
  silent! exe "set <S-Left>=\<Esc>b"
  silent! exe "set <S-Right>=\<Esc>f"
  silent! exe "set <F31>=\<Esc>d"
  map! <F31> <M-d>
endif

map <F1> <Esc>
map! <F1> <Esc>
if has("gui_running")
  map <F2> :Fancy<CR>
endif
map <F3> :cnext<CR>
map <F4> :cc<CR>
map <F5> :cprev<CR>
nmap <silent> <F6> :if &previewwindow<Bar>pclose<Bar>elseif exists(':Gstatus')<Bar>exe 'Gstatus'<Bar>else<Bar>ls<Bar>endif<CR>
nmap <silent> <F7> :if exists(':Glcd')<Bar>exe 'Glcd'<Bar>elseif exists(':Rlcd')<Bar>exe 'Rlcd'<Bar>else<Bar>lcd %:h<Bar>endif<CR>
map <F8> :wa<Bar>make<CR>
map <silent> <F11> :if exists(":BufExplorer")<Bar>exe "BufExplorer"<Bar>else<Bar>buffers<Bar>endif<CR>
map <C-F4> :bdelete<CR>
noremap <S-Insert> <MiddleMouse>
noremap! <S-Insert> <MiddleMouse>
map <Leader>l <Plug>CapsLockToggle
nmap du <Plug>SpeedDatingNowUTC
nmap dx <Plug>SpeedDatingNowLocal
inoremap <silent> <C-G><C-T> <C-R>=repeat(complete(col('.'),map(["%Y-%m-%d %H:%M:%S","%a, %d %b %Y %H:%M:%S %z","%Y %b %d","%d-%b-%y","%a %b %d %T %Z %Y"],'strftime(v:val)')+[localtime()]),0)<CR>
" Merge consecutive empty lines and clean up trailing whitespace
map <Leader>fm :g/^\s*$/,/\S/-j<Bar>%s/\s\+$//<CR>
" --------------------------------------------------------------
" windows motions
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
map <C-+> <C-w>+
map <C--> <C-w>-
" ---------------
nnoremap <Leader>c mz"dyy"dp`z
vnoremap <Leader>c "dymz"dP`z
nnoremap ; :
nnoremap ,; ;
"PHP mappings
autocmd FileType php noremap L f$l
autocmd FileType php noremap H F$l

" Section: Autocommands {{{1
" --------------------------

if has("autocmd")
  if $HOME !~# '^/Users/'
    filetype off " Debian preloads this before the runtimepath is set
  endif
  if version>600
    filetype plugin indent on
  else
    filetype on
  endif
  augroup FTMisc " {{{2
    autocmd!

    autocmd FocusLost * silent! wall
    autocmd BufNewFile,BufReadPost *.coffee setl sw=2 expandtab
    autocmd FocusGained * if !has('win32') | silent! call fugitive#reload_status() | endif
    autocmd SourcePre */macros/less.vim set laststatus=0 cmdheight=1
    if v:version >= 700 && isdirectory(expand("~/.trash"))
      autocmd BufWritePre,BufWritePost * if exists("s:backupdir") | set backupext=~ | let &backupdir = s:backupdir | unlet s:backupdir | endif
      autocmd BufWritePre ~/*
            \ let s:path = expand("~/.trash").strpart(expand("<afile>:p:~:h"),1) |
            \ if !isdirectory(s:path) | call mkdir(s:path,"p") | endif |
            \ let s:backupdir = &backupdir |
            \ let &backupdir = escape(s:path,'\,').','.&backupdir |
            \ let &backupext = strftime(".%Y%m%d%H%M%S~",getftime(expand("<afile>:p")))
    endif

    autocmd User Rails-javascript setlocal ts=2
    autocmd User Fugitive if filereadable(fugitive#buffer().repo().dir('fugitive.vim')) | source `=fugitive#buffer().repo().dir('fugitive.vim')` | endif

    autocmd BufNewFile */init.d/*
          \ if filereadable("/etc/init.d/skeleton") |
          \ 0r /etc/init.d/skeleton |
          \ $delete |
          \ silent! execute "%s/\\$\\(Id\\):[^$]*\\$/$\\1$/eg" |
          \ endif |
          \ set ft=sh | 1

    autocmd BufNewFile */.netrc,*/.fetchmailrc,*/.my.cnf let b:chmod_new="go-rwx"
    autocmd BufNewFile * let b:chmod_exe=1
    autocmd BufWritePre * if exists("b:chmod_exe") |
          \ unlet b:chmod_exe |
          \ if getline(1) =~ '^#!' | let b:chmod_new="+x" | endif |
          \ endif
    autocmd BufWritePost,FileWritePost * if exists("b:chmod_new")|
          \ silent! execute "!chmod ".b:chmod_new." <afile>"|
          \ unlet b:chmod_new|
          \ endif

    autocmd BufWritePost,FileWritePost ~/.Xdefaults,~/.Xresources silent! !xrdb -load % >/dev/null 2>&1
    autocmd BufWritePre,FileWritePre /etc/* if &ft == "dns" |
          \ exe "normal msHmt" |
          \ exe "gl/^\\s*\\d\\+\\s*;\\s*Serial$/normal ^\<C-A>" |
          \ exe "normal g`tztg`s" |
          \ endif
    autocmd BufReadPre *.pdf setlocal binary
    autocmd BufReadCmd *.jar call zip#Browse(expand("<amatch>"))
    autocmd FileReadCmd *.doc execute "read! antiword \"<afile>\""
    autocmd CursorHold,BufWritePost,BufReadPost,BufLeave *
      \ if isdirectory(expand("<amatch>:h")) | let &swapfile = &modified | endif
  augroup END " }}}2
  augroup FTCheck " {{{2
    autocmd!
    autocmd BufNewFile,BufRead */apache2/[ms]*-*/* set ft=apache
    autocmd BufNewFile,BufRead *named.conf* set ft=named
    autocmd BufNewFile,BufRead *.cl[so],*.bbl set ft=tex
    autocmd BufNewFile,BufRead /var/www/*.module set ft=php
    autocmd BufNewFile,BufRead *.vb set ft=vbnet
    autocmd BufNewFile,BufRead *.CBL,*.COB,*.LIB set ft=cobol
    autocmd BufNewFile,BufRead /var/www/*
          \ let b:url=expand("<afile>:s?^/var/www/?http://localhost/?")
    autocmd BufNewFile,BufRead /etc/udev/*.rules set ft=udev
" autocmd BufNewFile,BufRead,StdinReadPost *
" \ if !did_filetype() && (getline(1) =~ '^!!\@!'
" \ || getline(2) =~ '^!!\@!' || getline(3) =~ '^!'
" \ || getline(4) =~ '^!' || getline(5) =~ '^!') |
" \ setf router |
" \ endif
    autocmd BufRead * if ! did_filetype() && getline(1)." ".getline(2).
          \ " ".getline(3) =~? '<\%(!DOCTYPE \)\=html\>' | setf html | endif
    autocmd BufNewFile,BufRead *.txt,README,INSTALL,NEWS,TODO if &ft == ""|set ft=text|endif
  augroup END " }}}2
  augroup FTOptions " {{{2
    autocmd!
    autocmd FileType c,cpp,cs,java setlocal ai et sta sw=4 sts=4 cin
    autocmd FileType sh,csh,tcsh,zsh setlocal ai et sta sw=4 sts=4
    autocmd FileType tcl,perl,python setlocal ai et sta sw=4 sts=4
    autocmd FileType markdown,liquid setlocal ai et sta sw=2 sts=2 tw=72
    autocmd FileType javascript setlocal ai et sta sw=2 sts=2 ts=2 cin isk+=$
    autocmd FileType php,aspperl,aspvbs,vb setlocal ai et sta sw=4 sts=4
    autocmd FileType apache,sql,vbnet setlocal ai et sta sw=4 sts=4
    autocmd FileType tex,css,scss setlocal ai et sta sw=2 sts=2
    autocmd FileType html,xhtml,wml,cf setlocal ai et sta sw=2 sts=2
    autocmd FileType xml,xsd,xslt setlocal ai et sta sw=2 sts=2 ts=2
    autocmd FileType eruby,yaml,ruby setlocal ai et sta sw=2 sts=2
    autocmd FileType cucumber setlocal ai et sta sw=2 sts=2 ts=2
    autocmd FileType text,txt,mail setlocal ai com=fb:*,fb:-,n:>
    autocmd FileType sh,zsh,csh,tcsh inoremap <silent> <buffer> <C-X>! #!/bin/<C-R>=&ft<CR>
    autocmd FileType perl,python,ruby inoremap <silent> <buffer> <C-X>! #!/usr/bin/<C-R>=&ft<CR>
    autocmd FileType sh,zsh,csh,tcsh,perl,python,ruby imap <buffer> <C-X>& <C-X>!<Esc>o <C-U># $I<C-V>d$<Esc>o <C-U><C-X>^<Esc>o <C-U><C-G>u
    autocmd FileType c,cpp,cs,java,perl,javscript,php,aspperl,tex,css let b:surround_101 = "\r\n}"
    autocmd User ragtag if &sw == 8 | setlocal sw=2 sts=2 ts=2 | endif
    autocmd FileType apache setlocal commentstring=#\ %s
    autocmd FileType aspvbs,vbnet setlocal comments=sr:'\ -,mb:'\ \ ,el:'\ \ ,:',b:rem formatoptions=crq
    autocmd FileType asp* runtime! indent/html.vim
    autocmd FileType bst setlocal ai sta sw=2 sts=2
    autocmd FileType cobol setlocal ai et sta sw=4 sts=4 tw=72 makeprg=cobc\ -x\ -Wall\ %
    autocmd FileType cs silent! compiler cs | setlocal makeprg=gmcs\ %
    autocmd FileType css silent! setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType cucumber silent! compiler cucumber | setl makeprg=cucumber\ "%:p" | imap <buffer><expr> <Tab> pumvisible() ? "\<C-N>" : (CucumberComplete(1,'') >= 0 ? "\<C-X>\<C-O>" : (getline('.') =~ '\S' ? ' ' : "\<C-I>"))
    autocmd FileType git,gitcommit setlocal foldmethod=syntax foldlevel=1
    autocmd FileType gitcommit setlocal spell
    autocmd FileType gitrebase nnoremap <buffer> S :Cycle<CR>
    autocmd FileType help setlocal ai fo+=2n | silent! setlocal nospell
    autocmd FileType help nnoremap <silent><buffer> q :q<CR>
    autocmd FileType html setlocal iskeyword+=~
    autocmd FileType java silent! compiler javac | setlocal makeprg=javac\ %
    autocmd FileType mail if getline(1) =~ '^[A-Za-z-]*:\|^From ' | exe 'norm gg}' |endif|silent! setlocal spell
    autocmd FileType perl silent! compiler perl
    autocmd FileType pdf setlocal foldmethod=syntax foldlevel=1
    autocmd FileType ruby setlocal tw=79 isfname+=: comments=:#\ " | let &includeexpr = 'tolower(substitute(substitute('.&includeexpr.',"\\(\\u\\+\\)\\(\\u\\l\\)","\\1_\\2","g"),"\\(\\l\\|\\d\\)\\(\\u\\)","\\1_\\2","g"))'
    autocmd FileType ruby
          \ if expand('%') =~# '_test\.rb$' |
          \ compiler rubyunit | setl makeprg=testrb\ \"%:p\" |
          \ elseif expand('%') =~# '_spec\.rb$' |
          \ compiler rspec | setl makeprg=rspec\ \"%:p\" |
          \ else |
          \ compiler ruby | setl makeprg=ruby\ -wc\ \"%:p\" |
          \ endif
    autocmd User Bundler if &makeprg !~ 'bundle' | setl makeprg^=bundle\ exec\ | endif
    autocmd FileType text,txt setlocal tw=78 linebreak nolist
    autocmd FileType tex silent! compiler tex | setlocal makeprg=latex\ -interaction=nonstopmode\ % formatoptions+=l
    autocmd FileType tex if exists("*IMAP")|
          \ call IMAP('{}','{}',"tex")|
          \ call IMAP('[]','[]',"tex")|
          \ call IMAP('{{','{{',"tex")|
          \ call IMAP('$$','$$',"tex")|
          \ call IMAP('^^','^^',"tex")|
          \ call IMAP('::','::',"tex")|
          \ call IMAP('`/','`/',"tex")|
          \ call IMAP('`"\','`"\',"tex")|
          \ endif
    autocmd FileType vbnet runtime! indent/vb.vim
    autocmd FileType vim setlocal ai et sta sw=2 sts=2 keywordprg=:help
    autocmd FileType * if exists("+omnifunc") && &omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif
    autocmd FileType * if exists("+completefunc") && &completefunc == "" | setlocal completefunc=syntaxcomplete#Complete | endif
  augroup END "}}}2
endif " has("autocmd")

" Section: Bundles {{{1
" ---------------------
filetype off
Bundle 'gmarik/vundle'
Bundle 'BufClose.vim'
Bundle 'kchmck/vim-coffee-script'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-git'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-abolish'
Bundle 'groenewege/vim-less'
Bundle 'kien/ctrlp.vim'
Bundle 'L9'
Bundle 'digitaltoad/vim-jade'
Bundle 'nginx.vim'
Bundle 'jelera/vim-javascript-syntax'
Bundle 'Raimondi/delimitMate'
Bundle 'edsono/vim-matchit'
Bundle 'msanders/snipmate.vim'
Bundle 'othree/javascript-syntax.vim'
Bundle 'pangloss/vim-javascript'
Bundle 'scrooloose/nerdcommenter'
Bundle 'sjl/gundo.vim'
Bundle 'thinca/vim-poslist'
Bundle 'thinca/vim-quickrun'
Bundle 'tsaleh/vim-align'
Bundle 'tsaleh/vim-supertab'
Bundle 'kogakure/vim-sparkup'
Bundle 'Lokaltog/vim-powerline'
filetype on
" Section: Visual {{{1
" --------------------

" Switch syntax highlighting on, when the terminal has colors
if (&t_Co > 2 || has("gui_running")) && has("syntax")
  colorscheme molokai
  function! s:initialize_font()
    if exists("&guifont")
      if has("mac")
        set guifont=Monaco:h12
      elseif has("unix")
        if &guifont == ""
          set guifont=bitstream\ vera\ sans\ mono\ 11
        endif
      elseif has("win32")
        set guifont=DejaVu_Sans_Mono_for_Powerline:h10,Dejavu_Sans_Mono:h11,Courier\ New:h10
      endif
    endif
  endfunction

  command! -bar -nargs=0 Bigger :let &guifont = substitute(&guifont,'\d\+$','\=submatch(0)+1','')
  command! -bar -nargs=0 Smaller :let &guifont = substitute(&guifont,'\d\+$','\=submatch(0)-1','')
  noremap <M-,> :Smaller<CR>
  noremap <M-.> :Bigger<CR>

  if exists("syntax_on") || exists("syntax_manual")
  else
    syntax on
  endif
  set list

  augroup RCVisual
    autocmd!

    autocmd VimEnter * if !has("gui_running") | set background=dark notitle noicon | endif
    autocmd GUIEnter * set background=light title icon cmdheight=2 lines=25 columns=80 guioptions-=T
    autocmd GUIEnter * if has("diff") && &diff | set columns=165 | endif
    autocmd GUIEnter * silent! colorscheme molokai
    autocmd GUIEnter * call s:initialize_font()
    autocmd GUIEnter * let $GIT_EDITOR = 'false'
    autocmd Syntax css syn sync minlines=50
    autocmd Syntax csh hi link cshBckQuote Special | hi link cshExtVar PreProc | hi link cshSubst PreProc | hi link cshSetVariables Identifier
  augroup END
endif

" }}}1
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
autocmd! bufwritepost .vimrc source ~/.vimrc
" -*- vim -*- vim:set ft=vim et sw=2 sts=2 tw=78:
