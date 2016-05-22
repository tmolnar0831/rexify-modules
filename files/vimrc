syntax on

set so=10
set number
set expandtab
set autoindent
set smartindent
set hlsearch
set incsearch
set background=dark
set nobackup
set nowb
set noswapfile
set cursorline

" status line
set laststatus=2
set statusline=%F%m%r%h%w\ (%{&ff})[%Y][%l,%v][%p%%]

" paste toggle
set pastetoggle=<F12>

" default
set tabstop=2
set shiftwidth=2
set softtabstop=2
set showmatch

" shell
autocmd FileType sh set tabstop=2
autocmd FileType sh set shiftwidth=2
autocmd FileType sh set softtabstop=2
autocmd FileType sh set showmatch

" perl
autocmd FileType perl set tabstop=4
autocmd FileType perl set shiftwidth=4
autocmd FileType perl set softtabstop=4
autocmd FileType perl set showmatch
let perl_extended_vars=1
let perl_include_pod=1
" let perl_fold=1
" let perl_fold_blocks=1
nnoremap <silent> ,d :.!perl -MO=Deparse 2>/dev/null<cr>
vnoremap <silent> ,d :!perl -MO=Deparse 2>/dev/null<cr>
nnoremap <silent> ,t :%!perltidy -q<Enter>
vnoremap <silent> ,t :!perltidy -q<Enter>

" python
autocmd FileType python set tabstop=4
autocmd FileType python set shiftwidth=4
autocmd FileType python set softtabstop=4
autocmd FileType python set cc=79

" colorcolumn
map <F3> :set cc=79<cr>
map <F4> :set cc=0<cr>

" comment/uncomment
vmap ,c :s/^/#/<Enter>
vmap ,C :s/^#//<Enter>
