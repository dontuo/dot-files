"  ************************************************************************
"  **------------------------- Configurations ---------------------------**
"  ************************************************************************

set tabstop=2               " Set tab space
set cursorline              " Highlight current line
set hlsearch                " Highlight searched pattern
set shiftwidth=2            " Set shift width
set expandtab               " Insert space when tab is pressed
set laststatus=2            " Always display status line
set noswapfile              " Do not create swap file
set noshowmode              " Hide '-- INSERT --' from status line
set encoding=utf-8          " Set file encoding
set clipboard=unnamedplus   " Access system clipboard
set number                  " Display line number
set relativenumber          " Display relative line number
set rtp+=~/.fzf             " Set Fuzzy Finder
syntax on                   " Enable syntax hilighting
filetype plugin indent on   " Detect filetype that is edited, enable indent, plugin for specific file


"  ************************************************************************
"  **------------------------- Custom Keybindings -----------------------**
"  ************************************************************************

let mapleader = ","
nmap <LEADER>ne :NERDTreeToggle<CR>
imap kj <ESC>
nnoremap <CR> :noh<CR>              " Undo highlight
map <C-S-i> :Prettier<CR>           " Prettier shortcut
let g:EasyMotion_leader_key = '<Leader>'



"  ************************************************************************
"  **--------------------------- Ale ------------------------------------**
"  ************************************************************************

let g:ale_completion_enabled = 1
let b:ale_fixers = ['prettier', 'eslint']         " Fix files with prettier, and then ESLint.
let g:ale_fix_on_save = 1
let b:ale_linter_aliases = ['javascript', 'vue']  " Run both javascript and vue linters for vue files.
let b:ale_linters = ['eslint', 'vls']             " Select the eslint and vls linters.


"  ************************************************************************
"  **------------------------- Prettier ---------------------------------**
"  ************************************************************************

let g:prettier#config#print_width = 80                      " Max line length that prettier will wrap on, default: 80
let g:prettier#config#tab_width = 2                         " Number of spaces per indentation level, default: 2
let g:prettier#config#use_tabs = 'true'                     " Use tabs over spaces, default: false
let g:prettier#config#semi = 'true'                         " Print semicolons, default: true
let g:prettier#config#single_quote = 'false'                " Single quotes over double quotes, default: false
let g:prettier#config#bracket_spacing = 'true'              " Print spaces between brackets, default: true
let g:prettier#config#jsx_bracket_same_line = 'false'       " Put > on the last line instead of new line, default: false
let g:prettier#config#arrow_parens = 'avoid'                " avoid|always  default: avoid
let g:prettier#config#trailing_comma = 'none'               " none|es5|all  default: none
let g:prettier#config#parser = 'flow'                       " flow|babylon|typescript|css|less|scss|json|graphql|markdown  default: babylon
let g:prettier#config#config_precedence = 'prefer-file'     " cli-override|file-override|prefer-file
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync
autocmd FileType vue syntax sync fromstart
autocmd BufNewFile,BufRead *.vue set ft=vue


"  ************************************************************************
"  **------------------------- Polygot ----------------------------------**
"  ************************************************************************

let g:polyglot_disabled = ['graphql']         " Fix graphql error 


"  ************************************************************************
"  **------------------------- Theme ------------------------------------**
"  ************************************************************************

set background=dark
set termguicolors         " Enable true colors support

"let ayucolor="light"     " for light version of theme
"let ayucolor="mirage"    " for mirage version of theme
"let ayucolor="dark"      " for dark version of theme
"colorscheme ayu
"colorscheme PaperColor
colorscheme material
"colorscheme solarized



"  ************************************************************************
"  **------------------------- Airline ----------------------------------**
"  ************************************************************************

"let g:airline_theme='material'
let g:airline_theme='quantum'
let g:indentLine_char = '¦'
let g:indentLine_first_char = '¦'
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_setColors = 1


"  ************************************************************************
"  **------------------------- NerdTree ---------------------------------**
"  ************************************************************************

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif""
set completeopt-=preview
map  <C-l> :tabn<CR>
map  <C-h> :tabp<CR>
map ; :Files<CR>

autocmd FileType javascript set formatprg=prettier\ --stdin       " Set prettier for auto complete
autocmd FileType javascript set number                            " Set line number on specific files only
autocmd FileType php set number
autocmd FileType css set number
autocmd FileType vue syntax sync fromstart



"  ************************************************************************
"  **------------------------- NerdTree ---------------------------------**
"  ************************************************************************

" Set the runtime path to include Vundle and initialize
" alternatively, pass a path where Vundle should install plugins
" call vundle#begin('~/some/path/here')
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim' 
Plugin 'Valloric/YouCompleteMe'
Plugin 'prettier/vim-prettier'
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'ayu-theme/ayu-vim'
Plugin 'scrooloose/nerdtree'
Plugin 'chrisbra/NrrwRgn'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'Yggdroot/indentLine'
Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugin 'junegunn/fzf.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'itchyny/lightline.vim'
Plugin 'danro/rename.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'jiangmiao/auto-pairs'
Plugin 'lifepillar/vim-solarized8'
Plugin 'tyrannicaltoucan/vim-quantum'
Plugin 'posva/vim-vue'
Plugin 'kaicataldo/material.vim'
Plugin 'sheerun/vim-polyglot'
Plugin 'w0rp/ale'

" All of your Plugins must be added before the following line
call vundle#end()            " required
