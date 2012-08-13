"Use Vim settings, rather then Vi settings (much better!).
"This must be first, because it changes other options as a side effect.
set nocompatible

colorscheme darkzen

set backspace=indent,eol,start " allow backspacing over everything in insert mode
set history=1000               " store lots of :cmdline history
set showcmd                    " show incomplete cmds down the bottom
set showmode                   " show current mode down the bottom
set incsearch                  " find the next match as we type the search
set hlsearch                   " highlight searches by default
set nowrap                     " don't wrap lines by default...
set linebreak                  " ...but do it intelligently if we :set wrap
set autochdir                  " change current directory to opened file
set number                     " line numbers
set pastetoggle=<F5>           " sets paste mode
set hidden                     " don't close abandoned buffers

set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent

set nojoinspaces               " two spaces after a period is soooo archaic

set foldmethod=indent          " fold based on indent
set foldnestmax=3              " deepest fold is 3 levels
set nofoldenable               " don't fold by default

set wildmode=list:longest      " make cmdline tab completion similar to bash
set wildmenu                   " enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~    " stuff to ignore when tab completing

set formatoptions-=o           " don't continue comments when pushing o/O

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

" make <c-l> clear the highlight as well as redraw
nnoremap <C-L> :nohls<CR><C-L>
inoremap <C-L> <C-O>:nohls<CR>

" make Y consistent with C and D
nnoremap Y y$

" make Q do something more useful
nnoremap Q @q

" Insert returns around braces
let g:delimitMate_expand_cr=1

" keep highlight when shifting blocks
vmap > >gv
vmap < <gv

" use ctrl-arrow to switch windows
nmap <C-Left> <C-w>h
nmap <C-Down> <C-w>j
nmap <C-Up> <C-w>k
nmap <C-Right> <C-w>l

set statusline=%f  " tail of the filename
set statusline+=%h " help file flag
set statusline+=%y " filetype
set statusline+=%r " read only flag
set statusline+=%m " modified flag

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
set statusline+=%{StatuslineLongLineWarning()}      " [#...] long line warning

set statusline+=%=                                  " left/right separator
set statusline+=%{StatuslineCurrentHighlight()}\ \  " current highlight
set statusline+=col\ %c,\                           " cursor column
set statusline+=line\ %l/%L                         " cursor line/total lines
set statusline+=\ %P                                " percent through file
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


"return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
    let name = synIDattr(synID(line('.'),col('.'),1),'name')
    if name == ''
        return ''
    else
        return '[' . name . ']'
    endif
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

"return a warning for "long lines" where "long" is either &textwidth or 80 (if
"no &textwidth is set)
"
"return '' if no long lines
"return '[#x,my,$z] if long lines are found, were x is the number of long
"lines, y is the median length of the long lines and z is the length of the
"longest line
function! StatuslineLongLineWarning()
    if !exists("b:statusline_long_line_warning")
        let long_line_lens = s:LongLines()

        if len(long_line_lens) > 0
            let b:statusline_long_line_warning = "[" .
                        \ '#' . len(long_line_lens) . "," .
                        \ 'm' . s:Median(long_line_lens) . "," .
                        \ '$' . max(long_line_lens) . "]"
        else
            let b:statusline_long_line_warning = ""
        endif
    endif
    return b:statusline_long_line_warning
endfunction


"return a list containing the lengths of the long lines in this buffer
function! s:LongLines()
    let threshold = (&tw ? &tw : 80)
    let spaces = repeat(" ", &ts)

    let long_line_lens = []

    let i = 1
    while i <= line("$")
        let len = strlen(substitute(getline(i), '\t', spaces, 'g'))
        if len > threshold
            call add(long_line_lens, len)
        endif
        let i += 1
    endwhile

    return long_line_lens
endfunction


"find the median of the given array of numbers
function! s:Median(nums)
    let nums = sort(a:nums)
    let l = len(nums)

    if l % 2 == 1
        let i = (l-1) / 2
        return nums[i]
    else
        return (nums[l/2] + nums[(l/2)-1]) / 2
    endif
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
