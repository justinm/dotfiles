" Settings for both VIM and GVIM

"------------------------------------------------------------------------------
" PREFERENCES
"------------------------------------------------------------------------------
" Allows multiple lines to be pasted correctly
vnoremap p <Esc>:let current_reg = @"<CR>gvs<C-R>=current_reg<CR><Esc>

"------------------------------------------------------------------------------
" VARIABLE SETTINGS
"------------------------------------------------------------------------------
set backspace=indent,eol,start
set history=100
set incsearch
set nocompatible
set foldenable
set foldmethod=indent
set fdm=marker
set foldclose=all
set nowrap
set number
set ruler
set showcmd
set showmatch
set shiftwidth=4
set softtabstop=4
set tabstop=4
set undolevels=1000
set autoindent
set modelines=5

autocmd!
autocmd BufRead,BufNewFile,FileReadPost *.py source ~/.vim/python
autocmd BufRead,BufNewFile,FileReadPost *.py set expandtab

" This beauty remembers where you were the last time you edited the file, and returns to the same position.
autocmd BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

filetype on
filetype plugin on

syntax on

colorscheme torte

let php_sql_query=1
let php_htmlInStrings=1

set diffopt="iwhite"
set diffexpr=MyDiff()
function MyDiff()
  let opt = ""
  if &diffopt =~ "icase"
    let opt = opt . "-i "
  endif
  if &diffopt =~ "iwhite"
    let opt = opt . "-b "
  endif
  silent execute "!diff -a --minimal " . opt . v:fname_in . " " . v:fname_new .  " > " . v:fname_out
  silent execute "redraw!"
endfunction

highlight OverLength ctermbg=red ctermfg=white guibg=#592929
highlight ExtraSpace ctermbg=red ctermfg=white guibg=#592929

call pathogen#infect()

"match OverLength /\%81v.\+/
match ExtraSpace /[ \t]\+$/
