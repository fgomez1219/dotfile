colorscheme sonokai

" FZF
set grepprg=rg\ --no-heading\ --vimgrepr
" FZF shortcuts
nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <C-g> :GFiles<CR>
nnoremap <silent> <C-f> :Buffers<CR>
nnoremap <C-y> :Rg!

" nerdtree config
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <leader><S-N> :NERDTreeFind<CR>
map <silent> <C-n> :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree
let NERDTreeShowHidden=1
"Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | wincmd p | endif
" Start NERDTree and put the cursor back in the other window.
"autocmd VimEnter * NERDTree | wincmd p

" airline
let g:airline_theme = "dark"
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#branch#enabled = 1

"let g:move_key_modifier = 'C'
"
"vim autosave
"map <silent> <C-s> :w<CR>
let g:auto_save = 1
"let g:auto_save_write_all_buffers = 1

" python-syntax
let g:python_highlight_all = 1

"indentLine
let g:indentLine_char = '|'
" coc conf
let g:coc_global_extensions = [ 'coc-tsserver', 'coc-css', 'coc-python', 'coc-kotlin' ]
let g:coc_node_path = "/home/eurekalabs/.nvm/versions/node/v18.12.1/bin/node""
nmap <silent> <leader>gd <Plug>(coc-definition)
nmap <silent> <leader>gy <Plug>(coc-type-definition)
nmap <silent> <leader>gi <Plug>(coc-implementation)
nmap <silent> <leader>gr <Plug>(coc-references)
"moving lines
"nnoremap <A-j> :m .+1<CR>==
"nnoremap <A-k> :m .-2<CR>==
"inoremap <A-j> <Esc>:m .+1<CR>==gi
"inoremap <A-k> <Esc>:m .-2<CR>==gi
"vnoremap <A-j> :m '>+1<CR>gv=gv
"vnoremap <A-k> :m '<-2<CR>gv=gv

" andromeda for sonokai
"if has('termguicolors')
  "set termguicolors
"endif

 "The configuration options should be placed before `colorscheme sonokai`.
"let g:sonokai_style = 'andromeda'
"let g:sonokai_enable_italic = 1
"let g:sonokai_disable_italic_comment = 1

"colorscheme sonokai
set termguicolors
let ayucolor="dark"
colorscheme ayu

" copy full/relative path of open file
nnoremap <Leader>fp :let @+=expand('%:p')<CR>
nnoremap <Leader>rp :let @+=expand('%:')<CR>

" Make adjusing split sizes a bit more friendly
noremap <silent> <C-Left> :vertical resize +5<CR>
noremap <silent> <C-Right> :vertical resize -5<CR>
noremap <silent> <C-Up> :resize +5<CR>
noremap <silent> <C-Down> :resize -5<CR>
