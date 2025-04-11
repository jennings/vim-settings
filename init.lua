local vim = vim
local Plug = vim.fn['plug#']

-- vim-plug
vim.g.plug_shallow = 0
vim.call('plug#begin')
Plug('editorconfig/editorconfig-vim')
Plug('tpope/vim-fugitive')
Plug('tpope/vim-sensible')
Plug('tpope/vim-surround')
Plug('vim-airline/vim-airline')
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })
Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim', { ['branch'] = '0.1.x' })
vim.call('plug#end')

-- set background=dark
vim.cmd('silent! colorscheme cyberpunk')

-- easier to clear the highlight
-- nnoremap <Esc><Esc> <Esc><Esc>:noh<CR>

-- move around visually
-- nnoremap gj j
-- nnoremap gk k
-- nnoremap j gj
-- nnoremap k gk

-- make Y consistent with C and D
-- nnoremap Y y$
vim.keymap.set('n', 'Y', 'y$')

-- make Q do something more useful
-- nnoremap Q @q
vim.keymap.set('n', 'Q', '@q')

-- keep highlight when shifting blocks
-- vnoremap > >gv
-- vnoremap < <gv
vim.keymap.set('v', '>', '>gv')
vim.keymap.set('v', '<', '<gv')

-- use ctrl-arrow to switch windows
-- nnoremap <C-h> <C-w>h
-- nnoremap <C-j> <C-w>j
-- nnoremap <C-k> <C-w>k
-- nnoremap <C-l> <C-w>l

-- nnoremap ; :Telescope find_files<CR>
vim.keymap.set('n', ';', ':Telescope find_files<CR>')

-- on Windows, use CTRL-C and CTRL-V for copy/paste
-- if has ("win32")
--     vnoremap <C-c> "+y
--     vnoremap <C-v> "+p
--     nnoremap <C-v> "+p
--     inoremap <C-v> <C-o>"+p
-- endif
