let mapleader = ","
let maplocalleader = ","
noremap <silent> <F1> :MiniBufExplorer<CR>
noremap <silent> <F2> :Project<CR>
noremap <silent> <F3> :call BufferList()<CR>
"noremap <silent> <F4> :TagbarToggle<cr>
noremap <silent> <F5> :NERDTreeToggle<cr>
noremap <silent> <F6> :YRToggle<cr>
noremap <silent> <F7> :GundoToggle<cr>
"noremap <silent> <F8> :!/usr/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' : '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
snoremap <expr> <C-p> pumvisible() ? '<C-n>' : '<C-p><C-r>=pumvisible() ? "\<lt>Up>" : ""<CR>'


set pastetoggle=<F10>
nmap <leader>l :set list!<CR>
map <C-k> <C-w>k
map <C-l> <C-w>l
map <C-+> <C-w>+
map <C--> <C-w>-
inoremap <C-C> <Esc>`^
nmap <silent> ,/ :nohlsearch<CR>
vnoremap     <Space> I<Space><Esc>gv
nnoremap <up>    <nop>
nnoremap <down>  <nop>
nnoremap <left>  <nop>
nnoremap <right> <nop>
inoremap <up>    <nop>
inoremap <down>  <nop>
inoremap <left>  <nop>
inoremap <right> <nop>
nnoremap j gj
nnoremap k gk
inoremap jj <ESC>
:map <C-T> <Esc>:tabnew<CR>
nnoremap <Leader>x :BufClose<CR>
map <leader>e :e! ~/.vimrc<cr>
autocmd! bufwritepost .vimrc source ~/.vimrc
nnoremap <Leader>o :bnext<CR>
nnoremap <Leader>i :bp<CR>
nnoremap <Leader>c mz"dyy"dp`z
vnoremap <Leader>c "dymz"dP`z
nnoremap <silent> <Leader>[ :tabprev<CR>
nnoremap <silent> <Leader>] :tabnext<CR>
nnoremap ; :
map <C-h> <C-w>h
map <C-j> <C-w>j
"PHP mappings
autocmd FileType php noremap L f$l
autocmd FileType php noremap H F$l
autocmd FileType php noremap <buffer> <C-F5> :call PhpSyntaxCheck()<cr>
autocmd FileType php inoremap <buffer> <C-F5> <esc>:call PhpSyntaxCheck()<cr>
" ...
