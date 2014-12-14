"Use Vim settings, rather then Vi settings (much better!).
"This must be first, because it changes other options as a side effect.
set nocompatible
set noexrc

colorscheme darkzen

set backspace=indent,eol,start " allow backspacing over everything in insert mode
set history=1000               " store lots of :cmdline history
set showcmd                    " show incomplete cmds down the bottom
set showmode                   " show current mode down the bottom
set incsearch                  " find the next match as we type the search
set hlsearch                   " highlight searches by default
set nowrap                     " don't wrap lines by default...
set linebreak                  " ...but do it intelligently if we :set wrap
set number                     " line numbers
set pastetoggle=<F5>           " sets paste mode
set hidden                     " don't close abandoned buffers

set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent

set nojoinspaces               " two spaces after a period is soooo archaic

set splitbelow
set splitright

set foldmethod=indent          " fold based on indent
set foldnestmax=3              " deepest fold is 3 levels
set nofoldenable               " don't fold by default

set wildmode=list:longest      " make cmdline tab completion similar to bash
set wildmenu                   " enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj       " ignore C stuff
set wildignore+=*~,*.swp       " ignore Vim cruft
set wildignore+=*/_site/*      " ignore Jekyll built scripts

set formatoptions-=o           " don't continue comments when pushing o/O
set formatoptions+=j           " remove comment leader when joining lines with J

set scrolloff=3                " scroll the viewport when X lines from top/bottom edges
set sidescrolloff=7            " scroll the viewport when X lines from left/right edges
set sidescroll=1               " minimum lines to scroll left/right

let mapleader = ","            " comma is easier to type

set mouse=a                    " use the mouse in all modes
set ttymouse=xterm2

set ignorecase                 " ignore case in searches
set smartcase                  " unless the search string has a capital letter

filetype plugin on             " load filetype plugins
filetype indent on             " load filetype indenting
syntax on                      " turn on syntax highlighting


call pathogen#infect()
call pathogen#helptags()


autocmd Filetype ruby      setlocal shiftwidth=2 softtabstop=2
autocmd Filetype haml      setlocal shiftwidth=2 softtabstop=2
autocmd Filetype coffee    setlocal shiftwidth=2 softtabstop=2
autocmd Filetype go        setlocal shiftwidth=8 softtabstop=8 noexpandtab
autocmd Filetype gitconfig setlocal shiftwidth=8 softtabstop=8 noexpandtab
autocmd Filetype snippets  setlocal shiftwidth=8 softtabstop=8 noexpandtab
autocmd Filetype yaml      setlocal shiftwidth=2 softtabstop=2

autocmd FileType go         compiler go

autocmd FileType lisp       let b:delimitMate_smart_quotes = 0

" add a new line above
inoremap <S-CR> <C-o>O

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

nnoremap <Leader>n :NERDTree<CR>
nnoremap <Leader>b :buffers<CR>:buffer<Space>

" netrw stuff
let g:netrw_list_hide='.*\.swp$,^_site/$'

" CtrlP: find a repository as the root
let g:ctrlp_working_path_mode = 'r'

" CtrlP: let's use it more often
nnoremap ; :CtrlPMixed<CR>

" NERDTree: Ignore stuff
let g:NERDTreeIgnore=[]
let g:NERDTreeIgnore+=['\~$']
let g:NERDTreeIgnore+=['\.py[cod]$']
let g:NERDTreeIgnore+=['\.[oa]$']
let g:NERDTreeChDirMode=2

set statusline=\ #%n " buffer number
set statusline+=\ %t " tail of the filename
set statusline+=\ %y " filetype
set statusline+=%r   " read only flag
set statusline+=%m   " modified flag

set statusline+=%{fugitive#statusline()}            " show git information

set statusline+=%#warningmsg#                                   " warnings
set statusline+=%{&ff!='unix'?'['.&ff.']':''}                   " warn on line endings
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''} " display non-UTF-8 encodings
set statusline+=%*                                              " end warnings

set statusline+=%#error#                            " errors
set statusline+=%{StatuslineTabWarning()}           " error on bad indenting
set statusline+=%{&paste?'[paste]':''}              " [paste] display a warning if &paste is set
set statusline+=%*                                  " end errors

set statusline+=%{StatuslineTrailingSpaceWarning()} " [\s] warn on trailing spaces

set statusline+=%=                                  " left/right separator
set statusline+=col\ %c,\                           " cursor column
set statusline+=line\ %l/%L                         " cursor line/total lines
set statusline+=\                                   " end with a space
set laststatus=2


"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

"recalculate the long line warning when idle and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_long_line_warning

"return '[\s]' if trailing white space is detected
"return '' otherwise
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")
        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = '[\s]'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction


"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let tabs = search('^\t', 'nw') != 0
        let spaces = search('^ ', 'nw') != 0

        if tabs && spaces
            let b:statusline_tab_warning =  '[mixed-indenting]'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = '[&expandtab]'
        else
            let b:statusline_tab_warning = ''
        endif
    endif
    return b:statusline_tab_warning
endfunction


"visual search mappings
function! s:VSetSearch()
    let temp = @@
    norm! gvy
    let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
    let @@ = temp
endfunction
vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>


"jump to last cursor position when opening a file
"dont do it when writing a commit log entry
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
    if &filetype !~ 'commit\c'
        if line("'\"") > 0 && line("'\"") <= line("$")
            exe "normal! g`\""
            normal! zz
        endif
    end
endfunction

"define :HighlightLongLines command to highlight the offending parts of
"lines that are longer than the specified length (defaulting to 80)
command! -nargs=? HighlightLongLines call s:HighlightLongLines('<args>')
function! s:HighlightLongLines(width)
    let targetWidth = a:width != '' ? a:width : 79
    if targetWidth > 0
        exec 'match Todo /\%>' . (targetWidth) . 'v/'
    else
        echomsg "Usage: HighlightLongLines [natural number]"
    endif
endfunction
