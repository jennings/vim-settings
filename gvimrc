if has("win32") || has("win64")
    set guifont=Consolas:h10
endif

if has("mac")
    set guifont=Inconsolata:h16.00
endif

set lines=42
set columns=150
if &diff
    let &columns = ((&columns*2 > 150)? 150: &columns*2)
endif

colorscheme obsidian2

set vb            " No audible bell
set guioptions-=T " No toolbar
set cursorline    " highlight current line
