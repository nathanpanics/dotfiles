"" Vim configurations
set autochdir
set number               " show current line number
set relativenumber
set laststatus=2
set statusline+=%F

" Color Theme
set termguicolors
set t_Co=256
set background=dark

" Auto closing brackets
:so ~/.dotfiles/vim/autopair.vim

" Plugins
call plug#begin('~/.vim/plugged')

Plug 'fatih/vim-go', {'do': ':GoInstallBinaries'}
" Disable vim-go mapping for :gd
let g:go_def_mapping_enabled = 0
let g:go_metalinter_autosave = 1
let g:go_list_type = 'locationlist'

" turn to next or previous errors, after open location list
nmap <leader>j :lnext<CR>
nmap <leader>k :lprevious<CR>

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', {'do': { -> fzf#install()}}
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" If fonts are not working install git@github.com:powerline/fonts.git
Plug 'vim-airline/vim-airline'
let g:airline_powerline_fonts = 1

Plug 'vim-airline/vim-airline-themes'
let g:airline_theme='jellybeans'

Plug 'tomasr/molokai'
Plug 'APZelos/blamer.nvim'
Plug 'tpope/vim-fugitive'

call plug#end()

colorscheme molokai
