colorscheme sonokai
"youComplete config
let g:ycm_collect_identifiers_from_tags_files = 1 " Let YCM read tags from Ctags file
let g:ycm_use_ultisnips_completer = 1 " Default 1, just ensure
let g:ycm_seed_identifiers_with_syntax = 1 " Completion for programming language's keyword
let g:ycm_complete_in_comments = 1 " Completion in comments
let g:ycm_complete_in_strings = 1 " Completion in string
"go to definition
nnoremap gd :YcmCompleter GoTo<CR>
"get doc
nnoremap doc :YcmCompleter GetDoc<CR>

" FZF
set grepprg=rg\ --no-heading\ --vimgrepr
" FZF shortcuts
nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <C-g> :GFiles<CR>
nnoremap <silent> <C-b> :Buffers<CR>
nnoremap <C-o> :Rg! 

" nerdtree config
"nnoremap <C-n>n :NERDTreeToggle<CR>
nnoremap <leader><S-N> :NERDTreeFind<CR>
map <silent> <C-n> :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree
let NERDTreeShowHidden=1
"Start NERDTree when Vim is started without file arguments.
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
" Start NERDTree and put the cursor back in the other window.
"autocmd VimEnter * NERDTree | wincmd p

" airline
let g:airline_theme = "dark"
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#branch#enabled = 1



" Trigger configuration. You need to change this to something other than <tab>
" if you use one of the following:
" " - https://github.com/Valloric/YouCompleteMe
" " - https://github.com/nvim-lua/completion-nvim
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
"
" " If you want :UltiSnipsEdit to split your window.
"let g:UltiSnipsEditSplit="vertical"
"
" vim-move with C
"let g:move_key_modifier = 'C'
"
"vim autosave
"map <silent> <C-s> :w<CR>
let g:auto_save = 1
"let g:auto_save_write_all_buffers = 1

" python-syntax
let g:python_highlight_all = 1
