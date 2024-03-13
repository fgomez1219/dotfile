" Python
" flake8 config
autocmd BufWritePost *.py call Flake8()
" flagging unnsecessary Whitespace
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
command! TrimWhitespace call TrimWhitespace()
" auto erase whitespace in python files upon saving
" autocmd BufWritePre *.py :call TrimWhitespace()
highlight ws ctermbg=red guibg=red
match ws /\s\+$/
autocmd BufWinEnter * match ws /\s\+$/
" ipdb
autocmd BufNewFile,BufRead *.py inoremap ;i __import__('ipdb').set_trace(context=30)<Esc>_

