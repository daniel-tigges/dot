let mapleader = " "

if ! filereadable(expand('~/.config/nvim/autoload/plug.vim'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ~/.config/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ~/.config/nvim/autoload/plug.vim
endif

call plug#begin('~/.config/nvim/plugged')
Plug 'tpope/vim-surround' " cs:- change surround from : to -
Plug 'jreybert/vimagit'
Plug 'tpope/vim-commentary' " gcc to comment out
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'kovetskiy/sxhkd-vim'
Plug 'ap/vim-css-color'
Plug 'kaicataldo/material.vim'
call plug#end()

" Basics
" mapping for all modes:   :map/:noremap
" mapping for normal mode: :nmap/:nnoremap
" mapping for visual mode: :vmap/:vnoremap
	set encoding=utf-8
	syntax on
	let g:material_terminal_italics=1 " enable italics
	let g:material_theme_style='default' " material theme style
	colorscheme material
	set background=dark    " Setting dark mode
	set termguicolors
	set number
	set mouse=a
	filetype plugin indent on
	set nocompatible
	set clipboard=unnamedplus
	inoremap jj <Esc>
	" Use ctrl-[hjkl] to select the active split!
	nmap <silent> <c-k> :wincmd k<CR>
	nmap <silent> <c-j> :wincmd j<CR>
	nmap <silent> <c-h> :wincmd h<CR>
	nmap <silent> <c-l> :wincmd l<CR>
	set nobackup
	set noswapfile
	set incsearch
	set ignorecase
	set smartcase
	set nohlsearch
	set tabstop=4
	set softtabstop=0
	set shiftwidth=4
" airline font
	let g:airline_powerline_fonts=1

" Enable autocompletion:
	"set wildmode=longest,list,full

" Spell-check set to <leader>o, 'o' for 'orthography':
	map <leader>o :setlocal spell! spelllang=en_us<CR>

" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
	set splitbelow splitright

" git-gutter
	set updatetime=250
	let g:gitgutter_max_signs = 500  " default value
	let g:gitgutter_override_sign_column_highlight = 0

" Copy selected text to system clipboard (requires gvim/nvim/vim-x11 installed):
	vnoremap <C-c> "+y
	vnoremap <C-x> "+d
	map <C-v> "+P"

" Automatically deletes all trailing whitespace on save.
	autocmd BufWritePre * %s/\s\+$//e

" Run xrdb whenever Xdefaults or Xresources are updated.
	autocmd BufWritePost *Xresources,*Xdefaults !xrdb %

