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
Plug 'fatih/vim-go'
Plug 'junegunn/fzf'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
" Plug 'OmniSharp/omnisharp-vim'
" Plug 'alvan/vim-closetag'
" Plug 'godlygeek/tabular'
" Plug 'juvenn/mustache.vim'
" Plug 'nvie/vim-rst-tables'
" Plug 'scrooloose/syntastic'
" Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
call plug#end()


"Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
match ExtraWhitespace /\s\+$\| \+\ze\t/

set background=dark
let g:solarized_termcolors=256
colorscheme cyberpunk

" 4 spaces for most languages
set shiftwidth=4 softtabstop=4 expandtab

" 2 space languages
autocmd Filetype coffee     setlocal shiftwidth=2 softtabstop=2
autocmd Filetype haml       setlocal shiftwidth=2 softtabstop=2
autocmd Filetype javascript setlocal shiftwidth=2 softtabstop=2
autocmd Filetype json       setlocal shiftwidth=2 softtabstop=2
autocmd Filetype ruby       setlocal shiftwidth=2 softtabstop=2
autocmd Filetype yaml       setlocal shiftwidth=2 softtabstop=2

" tab languages
autocmd Filetype gitconfig  setlocal shiftwidth=8 softtabstop=8 noexpandtab
autocmd Filetype make       setlocal shiftwidth=8 softtabstop=8 noexpandtab
autocmd Filetype snippets   setlocal shiftwidth=8 softtabstop=8 noexpandtab

" golang
autocmd Filetype go         setlocal shiftwidth=8 softtabstop=8 noexpandtab
autocmd FileType go         compiler go
autocmd FileType go         nmap <Leader>r  <Plug>(go-run)
autocmd FileType go         nmap <Leader>b  <Plug>(go-build)
autocmd FileType go         nmap <Leader>t  <Plug>(go-test)
autocmd FileType go         nmap <Leader>c  <Plug>(go-coverage)
autocmd FileType go         nmap <Leader>d  <Plug>(go-doc)
autocmd FileType go         nmap <Leader>ds <Plug>(go-def-split)
autocmd FileType go         nmap <Leader>dv <Plug>(go-def-vertical)
autocmd FileType go         nmap <Leader>dt <Plug>(go-def-tab)
autocmd FileType go         nmap <Leader>i <Plug>(go-imports)
autocmd FileType go         nmap <Leader>? <Plug>(go-implements)
let g:syntastic_go_checkers = ['go', 'gofmt', 'golint']

autocmd FileType lisp       let b:delimitMate_smart_quotes = 0

let s:HomeDirectory = expand("<sfile>:p:h:h")

" OmniSharp stuff
let g:syntastic_cs_checkers = ['code_checker']
let g:omnicomplete_fetch_documentation=1
let g:OmniSharp_server_type = 'roslyn'
let g:OmniSharp_server_path = s:HomeDirectory . '/.omnisharp/OmniSharp.exe'
if has('unix')
    let g:OmniSharp_server_use_mono = 1
endif


let g:syntastic_rust_checkers = ['rustc']

" Search the current repository for the word under the cursor or selected text
nnoremap <leader>gg viwy:Ggrep <C-R>"<CR>
vnoremap <leader>gg y:Ggrep "<C-R>""<CR>

" terraform
autocmd Filetype terraform nnoremap <Leader>f :call TerraformFormatBuffer()<CR>
function! TerraformFormatBuffer()
    let l:winposition = winsaveview()
    %!terraform fmt -
    call winrestview(l:winposition)
endfunction

" Force OmniSharp to reload the solution. Useful when switching branches etc.
nnoremap <leader>rl :OmniSharpReloadSolution<cr>
nnoremap <leader>cf :OmniSharpCodeFormat<cr>

" (Experimental - uses vim-dispatch or vimproc plugin) - Start the omnisharp server for the current solution
nnoremap <leader>ss :OmniSharpStartServer<cr>
nnoremap <leader>sp :OmniSharpStopServer<cr>

augroup omnisharp_commands
    autocmd!

    "Set autocomplete function to OmniSharp (if not using YouCompleteMe completion plugin)
    autocmd FileType cs setlocal omnifunc=OmniSharp#Complete

    " Builds can also run asynchronously with vim-dispatch installed
    autocmd FileType cs nnoremap <leader>b :wa!<cr>:OmniSharpBuildAsync<cr>

    " automatic syntax check on events (TextChanged requires Vim 7.4)
    autocmd BufEnter,TextChanged,InsertLeave *.cs SyntasticCheck

    " Automatically add new cs files to the nearest project on save
    autocmd BufWritePost *.cs call OmniSharp#AddToProject()

    "show type information automatically when the cursor stops moving
    autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()

    "The following commands are contextual, based on the current cursor position.
    autocmd FileType cs nnoremap gd :OmniSharpGotoDefinition<cr>
    autocmd FileType cs nnoremap <leader>fi :OmniSharpFindImplementations<cr>
    autocmd FileType cs nnoremap <leader>ft :OmniSharpFindType<cr>
    autocmd FileType cs nnoremap <leader>fs :OmniSharpFindSymbol<cr>
    autocmd FileType cs nnoremap <leader>fu :OmniSharpFindUsages<cr>
    autocmd FileType cs nnoremap <leader>fm :OmniSharpFindMembers<cr> "finds members in the current buffer

    " cursor can be anywhere on the line containing an issue
    autocmd FileType cs nnoremap <leader>x  :OmniSharpFixIssue<cr>
    autocmd FileType cs nnoremap <leader>fx :OmniSharpFixUsings<cr>
    autocmd FileType cs nnoremap <leader>tt :OmniSharpTypeLookup<cr>
    autocmd FileType cs nnoremap <leader>dc :OmniSharpDocumentation<cr>
    autocmd FileType cs nnoremap <C-K> :OmniSharpNavigateUp<cr> "navigate up by method/property/field
    autocmd FileType cs nnoremap <C-J> :OmniSharpNavigateDown<cr> "navigate down by method/property/field
augroup END

" trigger ycm automatically
let g:ycm_semantic_triggers =  {
    \   'c' : ['->', '.'],
    \   'objc' : ['->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s',
    \             're!\[.*\]\s'],
    \   'ocaml' : ['.', '#'],
    \   'cpp,objcpp' : ['->', '.', '::'],
    \   'perl' : ['->'],
    \   'php' : ['->', '::'],
    \   'cs,java,javascript,typescript,d,python,perl6,scala,vb,elixir,go' : ['.'],
    \   'ruby' : ['.', '::'],
    \   'lua' : ['.', ':'],
    \   'erlang' : [':'],
    \ }

" slime stuff
let g:slime_target = "tmux"
let g:slime_default_config = { "socket_name": "default", "target_pane": ":.1" }
let g:slime_dont_ask_default = 1

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
nnoremap <Leader><Leader> :CtrlPBuffer<CR>
nnoremap <Leader>u :GundoToggle<CR>
nnoremap ; :FZF<CR>

nnoremap <Leader>? :YcmCompleter GetDoc<CR>

" on Windows, use CTRL-C and CTRL-V for copy/paste
if has ("win32")
    vnoremap <C-c> "+y
    vnoremap <C-v> "+p
    nnoremap <C-v> "+p
    inoremap <C-v> <C-o>"+p
endif

" netrw stuff
let g:netrw_list_hide='.*\.swp$,^_site/$'

" Gundo
let g:gundo_playback_delay=200

" CtrlP: find a repository as the root
let g:ctrlp_working_path_mode = 'r'
let g:ctrlp_open_multiple_files = 'ijr'
let g:ctrlp_custom_ignore = {
    \ 'dir': 'node_modules[\/]',
    \ }


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
