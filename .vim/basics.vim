"general config
set nocompatible              " be iMproved, required
filetype off                  " required
set backspace=indent,eol,start
let mapleader = "\<space>"
syntax on
set background=dark
set history=1000
set hidden  "buffer hiding to switch to another buffer without saving
set mouse=a
set noswapfile
set undofile
set undodir=~/.vim/undovim
set modifiable
set expandtab
set shiftwidth=4
set softtabstop=4
" set autoread
set incsearch
set hlsearch
set cursorline
set wildmenu
"rows numbers and relative to current row
set number
"wrap and linebreak text
set wrap
set linebreak
set nolist
" splits
set splitbelow
set splitright
" Enable folding
"set foldmethod=indent
"set foldlevel=0
set updatetime=100
nnoremap <space> za

autocmd FileType python set sw=4
autocmd FileType python set ts=4
autocmd FileType python set sts=4
autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``
" Fixes mouse issues using Alacritty terminal
set ttymouse=sgr

"numbers magic
:set number relativenumber

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

" split navigations
nnoremap <C-J> :sp<CR>
nnoremap <C-L> :vsp<CR>

"share clipboard between SO
"set clipboard=unnamed
" share clipboard only linux
" make sure that vim --version return +clipboard else install vim-gtk3
set clipboard=unnamedplus

"yml config
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" Nerdtree Bookmarks
let NERDTreeBookmarksFiles=expand("$HOME/.vim-NERDTreeBookmarks")
" Show the bookmarks table on startup
let NERDTreeShowBookmarks=1

" enable pathonge
execute pathogen#infect()
syntax on
filetype plugin indent on

" disable arrows navegation in vim
"let g:HardMode_level = 'wannabe'
"let g:HardMode_hardmodeMsg = 'Don''t use this!'
"autocmd VimEnter,BufNewFile,BufReadPost * silent! call HardMode()
