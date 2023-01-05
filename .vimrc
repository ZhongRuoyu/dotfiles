" https://vimhelp.org/filetype.txt.html
filetype plugin indent on

" https://vimhelp.org/syntax.txt.html
syntax enable

" https://vimhelp.org/options.txt.html
" display
set colorcolumn=81,121
set linebreak
set number
set ruler
set showcmd
" editing
set backspace=eol,indent,start
set matchpairs+=<:>
" indentation
" https://stackoverflow.com/q/1878974
set autoindent
set expandtab
set shiftwidth=2
set smartindent
set smarttab
set tabstop=2
" navigation
set scrolloff=5
set whichwrap+=<,>,[,]

" https://vimhelp.org/autocmd.txt.html
" overrides
autocmd FileType gitcommit
  \ setlocal colorcolumn=51,73
