if has("win32") || has("win64")
    set guifont=Inconsolata:h12.00
endif

if has("mac")
    set guifont=Inconsolata:h16.00
endif

set lines=42
set columns=100

colorscheme obsidian2

" No audible bell
set vb

" No toolbar
set guioptions-=T
