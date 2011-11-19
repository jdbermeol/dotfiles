set nocompatible "Improved
let VIMPATH = expand("<sfile>:h") . "/.vim"
exe "set rtp+=" . VIMPATH
exe "set rtp+=" . VIMPATH . "/bundle/vundle/"
try
  call vundle#rc(expand(VIMPATH . "/bundle"))
catch
  exe '!git clone https://github.com/gmarik/vundle.git ' . shellescape(VIMPATH . "/bundle/vundle/")
  source <sfile>
  exe "set rtp+=" . VIMPATH . "/bundle/vundle/"
  let FIRSTRUN = 1
endtry
" Section: Options  {{{1
" ----------------------
set clipboard+=unnamed
set autochdir
set ttyfast
set hidden
set history=1000
set undolevels=1000
set noerrorbells
set title
set encoding=utf-8
set showmode
set colorcolumn=80
set mouse=a
syntax enable
set synmaxcol=200
set ttyscroll=3
set autoindent
set autowrite
set backspace=2
set backupskip+=*.tmp,crontab.*
if has("balloon_eval") && has("unix")
  set balloon_eval
endif
if exists("&breakindent")
  set breakindent showbreak=+++
elseif has("gui_running")
  set showbreak=\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ +++
endif
set cmdheight=2
set complete-=i
set display=lastline
if has("eval")
  let &fileencodings = substitute(&fileencodings,"latin1","cp1252","")
endif
set fileformats=unix,dos,mac
set grepprg=ack
if has("eval")
  let &highlight = substitute(&highlight,'NonText','SpecialKey','g')
endif
set incsearch
set laststatus=2
set lazyredraw
if (&termencoding ==# 'utf-8' || &encoding ==# 'utf-8') && version >= 700
  let &listchars = "tab:\u21e5\u00b7,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u26ad"
else
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<
endif
set modelines=5
set mousemodel=popup
set pastetoggle=<F2>
set scrolloff=1
set showcmd
set showmatch
set smartcase
set smarttab
if exists("+spelllang")
  set spelllang=en_us
endif
set spellfile=~/.vim/spell/en.utf-8.add
set splitbelow " Split windows at bottom
set suffixes+=.dvi " Lower priority in wildcards
set tags+=../tags,../../tags,../../../tags,../../../../tags
set timeoutlen=1200 " A little bit more time for macros
set ttimeoutlen=50 " Make Esc work faster
if exists('+undofile')
  set undofile
endif
if v:version >= 700
  set viminfo=!,'20,<50,s10,h
endif
set visualbell
set virtualedit=block
set wildmenu
set wildmode=longest:full,full
set wildignore+=*~,*.aux,tags
set winaltkeys=no

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
    colorscheme molokai
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
    set t_Co=16
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

hi StatColor guibg=#95e454 guifg=black ctermbg=lightgreen ctermfg=black
hi Modified guibg=orange guifg=black ctermbg=lightred ctermfg=black

" Section: Status bar{{{1
" -----------------------
"statusline setup
set statusline=%f       "tail of the filename

"display a warning if fileformat isnt unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

"display a warning if file encoding isnt utf-8
set statusline+=%#warningmsg#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

set statusline+=%h      "help file flag
set statusline+=%y      "filetype
set statusline+=%r      "read only flag
set statusline+=%m      "modified flag

" display current git branch
set statusline+=%{fugitive#statusline()}

"display a warning if &et is wrong, or we have mixed-indenting
set statusline+=%#error#
set statusline+=%{StatuslineTabWarning()}
set statusline+=%*

set statusline+=%{StatuslineTrailingSpaceWarning()}

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"display a warning if &paste is set
set statusline+=%#error#
set statusline+=%{&paste?'[paste]':''}
set statusline+=%*

set statusline+=%=      "left/right separator
set statusline+=%{StatuslineCurrentHighlight()}\ \ "current highlight
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file
set laststatus=2        " Always show status line

"return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
    let name = synIDattr(synID(line('.'),col('.'),1),'name')
    if name == ''
        return ''
    else
        return '[' . name . ']'
    endif
endfunction

"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

"return '[\s]' if trailing white space is detected
"return '' otherwise
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")
        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = '[\s]'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let tabs = search('^\t', 'nw') != 0
        let spaces = search('^ ', 'nw') != 0

        if tabs && spaces
            let b:statusline_tab_warning =  '[mixed-indenting]'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = '[&et]'
        else
            let b:statusline_tab_warning = ''
        endif
    endif
    return b:statusline_tab_warning
endfunction

"return a warning for "long lines" where "long" is either &textwidth or 80 (if
"no &textwidth is set)
"
"return '' if no long lines
"return '[#x,my,$z] if long lines are found, were x is the number of long
"lines, y is the median length of the long lines and z is the length of the
"longest line
function! StatuslineLongLineWarning()
    if !exists("b:statusline_long_line_warning")
        let long_line_lens = s:LongLines()

        if len(long_line_lens) > 0
            let b:statusline_long_line_warning = "[" .
                        \ '#' . len(long_line_lens) . "," .
                        \ 'm' . s:Median(long_line_lens) . "," .
                        \ '$' . max(long_line_lens) . "]"
        else
            let b:statusline_long_line_warning = ""
        endif
    endif
    return b:statusline_long_line_warning
endfunction

"return a list containing the lengths of the long lines in this buffer
function! s:LongLines()
    let threshold = (&tw ? &tw : 80)
    let spaces = repeat(" ", &ts)

    let long_line_lens = []

    let i = 1
    while i <= line("$")
        let len = strlen(substitute(getline(i), '\t', spaces, 'g'))
        if len > threshold
            call add(long_line_lens, len)
        endif
        let i += 1
    endwhile

    return long_line_lens
endfunction

"find the median of the given array of numbers
function! s:Median(nums)
    let nums = sort(a:nums)
    let l = len(nums)

    if l % 2 == 1
        let i = (l-1) / 2
        return nums[i]
    else
        return (nums[l/2] + nums[(l/2)-1]) / 2
    endif
endfunction
" Plugin Settings {{{2

set undolevels=1000
set updatecount=100
set backup
exec("set undodir=" . VIMPATH . "/undo")
exec("set backupdir=" . VIMPATH . "/backup")
exec("set directory=" . VIMPATH . "/tmp")
"editting
set cindent
set smartindent
set matchtime=5
set ignorecase
set hlsearch
filetype plugin indent on
" Section: Commands {{{1
" -----------------------

if has("eval")
function! SL(function)
  if exists('*'.a:function)
    return call(a:function,[])
  else
    return ''
  endif
endfunction

command! -bar -nargs=1 -complete=file E :exe "edit ".substitute(<q-args>,'\(.*\):\(\d\+\):\=$','+\2 \1','')
command! -bar -nargs=0 SudoW :setl nomod|silent exe 'write !sudo tee % >/dev/null'|let &mod = v:shell_error
command! -bar -nargs=* -bang W :write<bang> <args>
command! -bar -nargs=0 -bang Scratch :silent edit<bang> \[Scratch]|set buftype=nofile bufhidden=hide noswapfile buflisted
command! -bar -count=0 RFC :e http://www.ietf.org/rfc/rfc<count>.txt|setl ro noma
command! -bar -nargs=* -bang -complete=file Rename :
      \ let v:errmsg = ""|
      \ saveas<bang> <args>|
      \ if v:errmsg == ""|
      \ call delete(expand("#"))|
      \ endif

function! Synname()
  if exists("*synstack")
    return map(synstack(line('.'),col('.')),'synIDattr(v:val,"name")')
  else
    return synIDattr(synID(line('.'),col('.'),1),'name')
  endif
endfunction

command! -bar Invert :let &background = (&background=="light"?"dark":"light")

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

function! OpenURL(url)
  if has("win32")
    exe "!start cmd /cstart /b ".a:url.""
  elseif $DISPLAY !~ '^\w'
    exe "silent !sensible-browser \"".a:url."\""
  else
    exe "silent !sensible-browser -T \"".a:url."\""
  endif
  redraw!
endfunction
command! -nargs=1 OpenURL :call OpenURL(<q-args>)
" open URL under cursor in browser
nnoremap gb :OpenURL <cfile><CR>
nnoremap gA :OpenURL http://www.answers.com/<cword><CR>
nnoremap gG :OpenURL http://www.google.com/search?q=<cword><CR>
nnoremap gW :OpenURL http://en.wikipedia.org/wiki/Special:Search?search=<cword><CR>

function! Run()
  let old_makeprg = &makeprg
  let old_errorformat = &errorformat
  try
    let cmd = matchstr(getline(1),'^#!\zs[^ ]*')
    if exists('b:run_command')
      exe b:run_command
    elseif cmd != '' && executable(cmd)
      wa
      let &makeprg = matchstr(getline(1),'^#!\zs.*').' %'
      make
    elseif &ft == 'mail' || &ft == 'text' || &ft == 'help' || &ft == 'gitcommit'
      setlocal spell!
    elseif exists('b:rails_root') && exists(':Rake')
      wa
      Rake
    elseif &ft == 'cucumber'
      wa
      compiler cucumber
      make %
    elseif &ft == 'ruby'
      wa
      if executable(expand('%:p')) || getline(1) =~ '^#!'
        compiler ruby
        let &makeprg = 'ruby'
        make %
      elseif expand('%:t') =~ '_test\.rb$'
        compiler rubyunit
        let &makeprg = 'ruby'
        make %
      elseif expand('%:t') =~ '_spec\.rb$'
        compiler rspec
        let &makeprg = 'rspec'
        make %
      elseif &makeprg ==# 'bundle'
        make
      elseif executable('pry') && exists('b:rake_root')
        execute '!pry -I"'.b:rake_root.'/lib" -r"%:p"'
      elseif executable('pry')
        !pry -r"%:p"
      else
        !irb -r"%:p"
      endif
    elseif &ft == 'html' || &ft == 'xhtml' || &ft == 'php' || &ft == 'aspvbs' || &ft == 'aspperl'
      wa
      if !exists('b:url')
        call OpenURL(expand('%:p'))
      else
        call OpenURL(b:url)
      endif
    elseif &ft == 'vim'
      w
      unlet! g:loaded_{expand('%:t:r')}
      return 'source %'
    elseif &ft == 'sql'
      1,$DBExecRangeSQL
    elseif expand('%:e') == 'tex'
      wa
      exe "normal :!rubber -f %:r && xdvi %:r >/dev/null 2>/dev/null &\<CR>"
    elseif &ft == 'dot'
      let &makeprg = 'dotty'
      make %
    else
      wa
      if &makeprg =~ '%'
        make
      else
        make %
      endif
    endif
    return ''
  finally
    let &makeprg = old_makeprg
    let &errorformat = old_errorformat
  endtry
endfunction
command! -bar Run :execute Run()

  runtime! plugin/matchit.vim
  runtime! macros/matchit.vim
endif

" Section: Mappings {{{1
" ----------------------

" Leader
let mapleader = ","
let maplocalleader = ","
" ------
nnoremap Q :<C-U>q<CR>
nnoremap Y y$
if exists(":hohls")
  nnoremap <silent> <C-L> :nohls<CR><C-L>
  nmap <silent> ,/ :nohls<CR>
endif
inoremap <C-C> <Esc>`^
nnoremap j gj
nnoremap k gk
inoremap jj <ESC>
nnoremap zS r<CR>ddkP=j
nnoremap =p m`=ap``
nnoremap == ==
vnoremap <M-<> <gv
vnoremap <M->> >gv
vnoremap <Space> I<Space><Esc>gv

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
inoremap <esc>   <nop>
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

if has("gui_mac")
  noremap <C-6> <C-^>
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
map <F9> :Run<CR>
map <silent> <F10> :let tagsfile = tempname()\|silent exe "!ctags -f ".tagsfile." \"%\""\|let &l:tags .= "," . tagsfile\|unlet tagsfile<CR>
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
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-git'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-abolish'
Bundle 'L9'
Bundle 'git://github.com/Raimondi/delimitMate.git'
Bundle 'git://github.com/edsono/vim-matchit.git'
Bundle 'git://github.com/fholgado/minibufexpl.vim.git'
Bundle 'git://github.com/msanders/snipmate.vim.git'
Bundle 'git://github.com/othree/javascript-syntax.vim.git'
Bundle 'git://github.com/pangloss/vim-javascript.git'
Bundle 'git://github.com/scrooloose/nerdcommenter.git'
Bundle 'git://github.com/scrooloose/syntastic.git'
Bundle 'git://github.com/sjl/gundo.vim.git'
Bundle 'git://github.com/skammer/vim-css-color.git'
Bundle 'git://github.com/thinca/vim-poslist.git'
Bundle 'git://github.com/thinca/vim-quickrun.git'
Bundle 'git://github.com/tsaleh/vim-align.git'
Bundle 'git://github.com/tsaleh/vim-supertab.git'
Bundle 'git://github.com/vim-scripts/YankRing.vim.git'
Bundle 'git://github.com/vim-scripts/octave.vim--.git'
filetype on
" Section: Visual {{{1
" --------------------

" Switch syntax highlighting on, when the terminal has colors
if (&t_Co > 2 || has("gui_running")) && has("syntax")
  function! s:initialize_font()
    if exists("&guifont")
      if has("mac")
        set guifont=Monaco:h12
      elseif has("unix")
        if &guifont == ""
          set guifont=bitstream\ vera\ sans\ mono\ 11
        endif
      elseif has("win32")
        set guifont=Consolas:h11,Courier\ New:h10
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
  if !exists('g:colors_name')
    if filereadable(expand("~/.vim/colors/tim.vim"))
      colorscheme tim
    elseif filereadable(expand("~/.vim/colors/tpope.vim"))
      colorscheme tpope
    endif
  endif

  augroup RCVisual
    autocmd!

    autocmd VimEnter * if !has("gui_running") | set background=dark notitle noicon | endif
    autocmd GUIEnter * set background=light title icon cmdheight=2 lines=25 columns=80 guioptions-=T
    autocmd GUIEnter * if has("diff") && &diff | set columns=165 | endif
    autocmd GUIEnter * silent! colorscheme vividchalk
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

if exists("FIRSTRUN")
  exe mkdir(VIMPATH . "/undo")
  exe mkdir(VIMPATH . "/backup")
  exe mkdir(VIMPATH . "/tmp")
  unlet FIRSTRUN
  exe "BundleInstall"
endif
autocmd! bufwritepost .vimrc source ~/.vimrc
" -*- vim -*- vim:set ft=vim et sw=2 sts=2 tw=78:
