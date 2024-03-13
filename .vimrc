"This script contains general configuration
source ~/.vim/basics.vim

"This script contains plugins specific settings
source ~/.vim/plugins.vim

"This script contains mapings and configuration of plugins
source ~/.vim/mapping.vim

" This scripts contains filetypes
source ~/.vim/filestypes.vim

function! PythonEnterFunc()
  let l:li = getline('.')
  execute "normal! a\<Cr>"
  if l:li =~ '([^)]*$'
    let l:pos = stridx(l:li, '(') + 1
    for i in range(l:pos)
      execute "normal! a\<Space>"
    endfor
  endif
endfunction

au FileType python inoremap <Cr> <Esc>:call PythonEnterFunc()<CR>a

"let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
"let &t_8b = "\<Esc>[48:2;%lu;%lu;%lum"
