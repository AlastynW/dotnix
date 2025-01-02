vim.cmd([[

""""""""""""""""""""""""""""""""""""""
" => Settings
"""""""""""""""""""""""""""""""""""""""
let mapleader = ","			    " Leader key
set clipboard+=unnamedplus
set number        " Line numbering
set hlsearch                  " No highlight
set ignorecase                  " Case Insensitive search
set showmatch
set smartcase
set nobackup                    " No backup files
set nowrap
set cursorline
set encoding=UTF-8
set scrolloff=10
set mouse= " Disable mouse


"""""""""""""""""""""""""""""""""""""""
" => Theme
"""""""""""""""""""""""""""""""""""""""
syntax on
filetype on 
filetype plugin on
set t_Co=256
set termguicolors

" start screen
let g:startify_custom_header = [
            \
            \ ' ██╗   ██╗██╗███╗   ███╗',
            \ ' ██║   ██║██║████╗ ████║',
            \ ' ██║   ██║██║██╔████╔██║',
            \ ' ╚██╗ ██╔╝██║██║╚██╔╝██║',
            \ '  ╚████╔╝ ██║██║ ╚═╝ ██║',
            \ '   ╚═══╝  ╚═╝╚═╝     ╚═╝',
          \]

"""""""""""""""""""""""""""""""""""""""
" => Code sytling
"""""""""""""""""""""""""""""""""""""""
set tabstop=4
set shiftwidth=4
set expandtab

" tabs
set hidden

]])

vim.opt.splitright = true
vim.opt.splitbelow = true
