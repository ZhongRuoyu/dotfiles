" https://vimhelp.org/filetype.txt.html
let g:python_recommended_style = 0
filetype plugin indent on

" https://vimhelp.org/syntax.txt.html
syntax enable

" https://vimhelp.org/options.txt.html
" display
set linebreak
set number
set ruler
set showcmd
set nowrap
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
" search
set hlsearch
set incsearch
" rulers
set colorcolumn=81,101,121
highlight ColorColumn ctermbg=darkgray
" whitespace display
if has("multi_byte")
  set list
  set listchars=
  set listchars+=tab:\\u21e5\\u0020
  " set listchars+=space:\\u00b7
  set listchars+=trail:\\u00b7
  set listchars+=extends:\\u00bb
  set listchars+=precedes:\\u00ab
  set listchars+=nbsp:\\u2423
else
  set list
  set listchars=
  set listchars+=tab:>-
  " set listchars+=space:.
  set listchars+=trail:.
  set listchars+=extends:>
  set listchars+=precedes:<
  set listchars+=nbsp:%
endif
" completion
set wildmenu
set wildmode=list:longest,list:full

" local configurations
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
