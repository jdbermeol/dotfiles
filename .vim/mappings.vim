let mapleader = ","
let maplocalleader = ","
map <F1> <ESC>
noremap <silent> <F2> :Project<CR>
noremap <silent> <F3> :call BufferList()<CR>
noremap <silent> <F4> :TlistToggle<cr>
noremap <silent> <F5> :NERDTreeToggle<cr>
noremap <silent> <F6> :YRToggle<cr>
noremap <silent> <F7> :GundoToggle<cr>
noremap <silent> <F8> :!/usr/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' : '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
snoremap <expr> <C-p> pumvisible() ? '<C-n>' : '<C-p><C-r>=pumvisible() ? "\<lt>Up>" : ""<CR>'


set pastetoggle=<F10>
nmap <leader>l :set list!<CR>
map <C-k> <C-w>k
map <C-l> <C-w>l
inoremap <C-C> <Esc>`^
nmap <silent> ,/ :nohlsearch<CR>
nnoremap j gj
vnoremap     <Space> I<Space><Esc>gv
nnoremap k gk
inoremap jj <ESC>
:let g:proj_flags="imstvcg"
:map <C-T> <Esc>:tabnew<CR>
" Open the Project Plugin
nnoremap <silent> <Leader>pal  :Project .vimproject<CR>
" Space will toggle folds!
nnoremap <Leader>x :BufClose<CR>
" Fast editing of the .vimrc
map <leader>e :e! ~/.vimrc<cr>
" When vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc
map <right> :bn<cr>
map <left> :bp<cr>

nmap <leader>w :w!<cr>
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
autocmd FileType php noremap L f$
autocmd FileType php noremap H F$
autocmd FileType php inoremap <C-F1> <ESC>:call PhpDocSingle()<CR>i
autocmd FileType php nnoremap <C-F1> :call PhpDocSingle()<CR>
autocmd FileType php vnoremap <C-F1> :call PhpDocRange()<CR>
autocmd FileType php noremap <buffer> <C-F5> :call PhpSyntaxCheck()<cr>
autocmd FileType php inoremap <buffer> <C-F5> <esc>:call PhpSyntaxCheck()<cr>
" ...
"autocomplete
