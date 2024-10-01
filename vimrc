"Use Vim settings, rather then Vi settings (much better!).
"This must be first, because it changes other options as a side effect.
set nocompatible
set noexrc

set history=1000               " store lots of :cmdline history
set showcmd                    " show incomplete cmds down the bottom
set showmode                   " show current mode down the bottom
set hlsearch                   " highlight searches by default
set nowrap                     " don't wrap lines by default...
set linebreak                  " ...but do it intelligently if we :set wrap
set number                     " line numbers
set pastetoggle=<F5>           " sets paste mode
set hidden                     " don't close abandoned buffers
set cursorline                 " where am I?
set relativenumber             " gonna try this again

" swap files
if has("win32")
    set dir^=~/vimfiles/swap
else
    set dir^=~/.vim/swap
    set dir-=~/tmp
    set backupskip=/tmp/*,/private/tmp/*    " fixes crontab editing
end

set smartindent

set nojoinspaces               " two spaces after a period is soooo archaic

set splitbelow
set splitright

set foldmethod=indent          " fold based on indent
set foldnestmax=3              " deepest fold is 3 levels
set nofoldenable               " don't fold by default

set wildmode=list:longest      " make cmdline tab completion similar to bash
set wildignore=*.o,*.obj       " ignore C stuff
set wildignore+=*~,*.swp       " ignore Vim cruft
set wildignore+=*/_site/*      " ignore Jekyll built scripts

set formatoptions-=o           " don't continue comments when pushing o/O

set sidescroll=1               " minimum lines to scroll left/right

let mapleader = ","            " comma is easier to type

set mouse=a                    " use the mouse in all modes
if !has('nvim')
    set ttymouse=xterm2
endif

set ignorecase                 " ignore case in searches
set smartcase                  " unless the search string has a capital letter

" vim-plug
let g:plug_shallow=0
call plug#begin()
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
call plug#end()

set background=dark
colorscheme cyberpunk

" easier to clear the highlight
nnoremap <Esc><Esc> <Esc><Esc>:noh<CR>

" move around visually
nnoremap gj j
nnoremap gk k
nnoremap j gj
nnoremap k gk

" make Y consistent with C and D
nnoremap Y y$

" make Q do something more useful
nnoremap Q @q

" keep highlight when shifting blocks
vnoremap > >gv
vnoremap < <gv

" use ctrl-arrow to switch windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap ; :Telescope find_files<CR>

" on Windows, use CTRL-C and CTRL-V for copy/paste
if has ("win32")
    vnoremap <C-c> "+y
    vnoremap <C-v> "+p
    nnoremap <C-v> "+p
    inoremap <C-v> <C-o>"+p
endif
