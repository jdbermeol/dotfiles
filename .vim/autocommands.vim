iab phpb $logger = Zend_Registry::get('logger');$logger->log($code,Zend_Log::INFO);Zend_Wildfire_Channel_HttpHeaders::getInstance()->flush();
iab phpv echo "<hr><pre>";var_dump($a);exit("debug ");
function! RunPhpcs()
    let l:filename=@%
    let l:phpcs_output=system('phpcs --report=csv --standard=Zend '.l:filename)
    echo l:phpcs_output
    let l:phpcs_list=split(l:phpcs_output, "\n")
    unlet l:phpcs_list[0]
    cexpr l:phpcs_list
    cwindow
endfunction

set errorformat+=\"%f\"\\,%l\\,%c\\,%t%*[a-zA-Z]\\,\"%m\"
command! Phpcs execute RunPhpcs()
"{{{Auto Commands
au BufWritePost *.php,*.js,*.pthml silent! !ctags -R &
" Automatically cd into the directory that the file is in
autocmd BufEnter * execute "cd".escape(expand("%:p:h"), ' ')
" Remove any trailing whitespace that is in the file
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif
au FileType php set omnifunc=phpcomplete#CompletePHP
"}}}

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
