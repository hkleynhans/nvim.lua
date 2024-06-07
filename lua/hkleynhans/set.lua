-- Set VIM options
vim.g.mapleader = ' '

vim.o.hlsearch = false
vim.o.incsearch = true

vim.o.mouse = 'a'
vim.o.cursorline = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.cmd [[colorscheme gruvbox]]

vim.o.pastetoggle = "<F2>"
vim.o.colorcolumn = tostring(80)

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

-- Set shell slash.  This makes slashes consistent (UNIX slashes) on Windows.
vim.cmd [[set ssl]]
