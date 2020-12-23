let mapleader = " "

if ! filereadable(expand('~/.config/nvim/autoload/plug.vim'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ~/.config/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ~/.config/nvim/autoload/plug.vim
endif

call plug#begin('~/.config/nvim/plugged')
Plug 'tpope/vim-fugitive' " git plugin
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim' " Git checkout plugin
Plug 'tpope/vim-surround' " cs:- change surround from : to -
Plug 'tpope/vim-commentary' " gcc to comment out
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'kovetskiy/sxhkd-vim' " highlight for sxhkd files
Plug 'ap/vim-css-color' " preview colors in source code
Plug 'kaicataldo/material.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Code completion
Plug 'sheerun/vim-polyglot'
Plug 'Chiel92/vim-autoformat' " Autoformat plugin
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
	set clipboard+=unnamedplus
	inoremap jj <Esc>
	set nobackup
	set nowritebackup
	set cmdheight=2
	set noswapfile
	set incsearch
	set ignorecase
	set smartcase
	set hlsearch
	set tabstop=4
	set softtabstop=4
	set shiftwidth=4
	set expandtab
	set autoindent
	set smartindent
	set hidden
	set shortmess+=c " Don't pass messages to ins-completion-menu
" airline font
	let g:airline_powerline_fonts=1
	let g:airline_theme = 'material'
" mac ctrl-c to esc
	inoremap <C-c> <esc>
" Use ctrl-[hjkl] to select the active split!
	nmap <silent> <c-k> :wincmd k<CR>
	nmap <silent> <c-j> :wincmd j<CR>
	nmap <silent> <c-h> :wincmd h<CR>
	nmap <silent> <c-l> :wincmd l<CR>
	nmap <silent> <leader>uu <C-W>=<CR> " update split sizes

" Open git status
	nmap <leader>gs :G<CR>
" Git merge left and right version
	nmap <leader>gf :diffget //2<CR>
	nmap <leader>gj :diffget //3<CR>
" open gitdiff
	set diffopt+=vertical
	nmap <leader>gd :Gdiffsplit<CR>
" git checkout config
	let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
	let $FZF_DEFAULT_OPTS='--reverse'
	nnoremap <leader>gc :GBranches<CR>
	nnoremap <C-p> :GFiles<CR>

" Spell-check set to <leader>o, 'o' for 'orthography':
	map <leader>o :setlocal spell! spelllang=en_us<CR>

" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
	set splitbelow splitright

" git-gutter
	set signcolumn=yes
	set updatetime=250
	let g:gitgutter_max_signs = 500  " default value
	let g:gitgutter_override_sign_column_highlight = 0

" Copy selected text to system clipboard (requires gvim/nvim/vim-x11 installed):
	vnoremap <C-c> "+y
	vnoremap <C-x> "+d
	map <C-v> "+P"

" Comment out and in
	" autocmd FileType apache setlocal commentstring=#\ %s
	nmap <leader>c gcc
	vmap <leader>c gcc

" Config for autoformatter
	"let g:python3_host_prog=/usr/bin/python
	noremap <leader>f :Autoformat<CR>
	"au BufWrite * :Autoformat
	" Add `:Format` command to format current buffer.
	" command! -nargs=0 Format :call CocAction('format')
	" nmap <leader>f <Plug>(coc-format)

" Automatically deletes all trailing whitespace on save.
	autocmd BufWritePre * %s/\s\+$//e

" Run xrdb whenever Xdefaults or Xresources are updated.
	autocmd BufWritePost *Xresources,*Xdefaults !xrdb %

" CoC configuration
" -------------------------------------------------------------------
	" correct comment highlighting for json
	autocmd FileType json syntax match Comment +\/\/.\+$+
	" coc extensions
	let g:coc_global_extensions=[ 'coc-python', 'coc-json', 'coc-omnisharp' ]
	" quick access to config file
	function! SetupCommandAbbrs(from, to)
  		exec 'cnoreabbrev <expr> '.a:from
       	 \ .' ((getcmdtype() ==# ":" && getcmdline() ==# "'.a:from.'")'
       	 \ .'? ("'.a:to.'") : ("'.a:from.'"))'
	endfunction

	" Use C to open coc config
	call SetupCommandAbbrs('C', 'CocConfig')

	function! s:check_back_space() abort
	  let col = col('.') - 1
	  return !col || getline('.')[col - 1]  =~# '\s'
	endfunction

	" Use tab for trigger completion with characters ahead and navigate.
	" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
	" other plugin before putting this into your config.
	inoremap <silent><expr> <TAB>
		  \ pumvisible() ? "\<C-n>" :
		  \ <SID>check_back_space() ? "\<TAB>" :
		  \ coc#refresh()
	inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

	" Use <c-space> to trigger completion.
	if has('nvim')
	  inoremap <silent><expr> <c-space> coc#refresh()
	else
	  inoremap <silent><expr> <c-@> coc#refresh()
	endif

	" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
	" position. Coc only does snippet and additional edit on confirm.
	" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
	if exists('*complete_info')
	  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
	else
	  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
	endif
	" GoTo code navigation.
	nmap <silent> <leader>gd <Plug>(coc-definition)
	nmap <silent> <leader>gy <Plug>(coc-type-definition)
	nmap <silent> <leader>gi <Plug>(coc-implementation)
	nmap <silent> <leader>gr <Plug>(coc-references)
	nnoremap <leader>cr :CocRestart
	" Symbol renaming.
	nmap <leader>rr <Plug>(coc-rename)

	" Formatting selected code.
	"xmap <leader>f  <Plug>(coc-format-selected)
	"nmap <leader>f  <Plug>(coc-format-selected)

" End of CoC configuration
