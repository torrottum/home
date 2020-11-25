" TODO: better comments

call plug#begin('~/.vim/plugged')
Plug 'junegunn/vim-plug'
let g:gruvbox_contrast_dark="hard"
Plug 'gruvbox-community/gruvbox'
Plug 'nanotech/jellybeans.vim'
Plug 'neovimhaskell/haskell-vim'
Plug 'tpope/vim-commentary'
Plug 'pangloss/vim-javascript'
Plug 'othree/es.next.syntax.vim'
Plug 'othree/yajs.vim'
Plug 'vimwiki/vimwiki'
Plug 'mattn/emmet-vim'
call plug#end()

" style
set termguicolors
colorscheme gruvbox
set number
set list
set listchars=tab:!·,trail:·,nbsp:!



" indent
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set autoindent
set smartindent

" search
set ignorecase
set smartcase
set incsearch

let mapleader = "-"

augroup xmonad
    autocmd BufWrite ~/.config/xmonad/*.hs !xmonad --recompile; xmonad --restart
augroup END
