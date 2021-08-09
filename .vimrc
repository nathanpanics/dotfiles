" Plugins
"
call plug#begin('~/.vim/plugged')

Plug 'fatih/vim-go', {'do': ':GoInstallBinaries'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', {'do': { -> fzf#install()}}
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tomasr/molokai'

call plug#end()

" Color Theme
set termguicolors
set t_Co=256
set background=dark
colorscheme molokai
let g:airline_theme='fairyfloss'

" Disable vim-go mapping for :gd
let g:go_def_mapping_enabled = 0

" Auto closing brackets
:so ~/.dotfiles/vim/autopair.vim

" Vim configurations
set autochdir
set number
set laststatus=2
set statusline+=%F

" Airline configurations
let g:airline_powerline_fonts = 1
