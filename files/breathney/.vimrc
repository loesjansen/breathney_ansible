syntax on
set number
set bg=dark
set nomodeline
set pastetoggle=<F9>

"map <F2> :tabnew<cr>
"map <F3> :tabnext<cr>
"map <F4> :tabprevious<cr>
map <F3> :w<cr>:previous<cr>
map <F4> :w<cr>:next<cr>

" latex-suite
set runtimepath+=/usr/share/vim/addons/
filetype plugin on
set grepprg=grep\ -nH\ $*
filetype indent on

" tab-completion
function InsertTabWrapper()
      let col = col('.') - 1
      if !col || getline('.')[col - 1] !~ '\k'
          return "\<tab>"
      else
          return "\<c-p>"
      endif
endfunction

inoremap <tab> <c-r>=InsertTabWrapper()<cr>
