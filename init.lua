-- require("hkleynhans")

-- Install Packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  vim.cmd [[packadd packer.nvim]]
end

-- Packages
require("packer").startup(function (use)
  use "wbthomason/packer.nvim"

  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    requires = {

      -- LSP Support
      {'neovim/nvim-lspconfig'},             -- Required
      {                                      -- Optional
        'williamboman/mason.nvim',
      },
      {'williamboman/mason-lspconfig.nvim'}, -- Optional

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},     -- Required
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-path'},
      {'hrsh7th/cmp-nvim-lsp'}, -- Required
      {'hrsh7th/cmp-nvim-lua'},
      {'L3MON4D3/LuaSnip'},     -- Required
    }
  }

  -- use { "TimUntersberger/neogit", requires = "nvim-lua/plenary.nvim" }

  use "nvim-lua/plenary.nvim"
  use "nvim-lua/popup.nvim"
  use "nvim-lua/telescope.nvim"

  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate"
  }

  use "editorconfig/editorconfig-vim"
  use "morhetz/gruvbox"
  use "navarasu/onedark.nvim" -- Theme inspired by Atom
  use "nvim-lualine/lualine.nvim" -- Fancier statusline

  use "mfussenegger/nvim-dap"

  use "Civitasv/cmake-tools.nvim"
  use "rgroli/other.nvim"
  use "famiu/bufdelete.nvim"

  use "BurntSushi/ripgrep"

  use "lervag/vimtex"

  use "neomake/neomake"

  if is_bootstrap then
      require("packer").sync()
  end
end)


-- TREESITTER
require('nvim-treesitter.configs').setup({
	ensure_installed = {"c", "cpp", "lua", "vim", "go", "javascript", "typescript", "rust"},

    sync_install = false,
    auto_install = true,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
})

-- LSP
local lsp = require("lsp-zero").preset({})

lsp.ensure_installed({'clangd','lua_ls'})

lsp.setup_servers({
    'clangd',
    'lua_ls',
})

local cmp = require("cmp")
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-space>'] = cmp.mapping.complete(),
})

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
	warn = 'W',
	hint = 'H',
        info = 'I',
    }
})

lsp.on_attach(function(client, buffer)
    local opts = {buffer = bufnr, remap = false}

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()

-- TELESCOPE
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>f", telescope.find_files, {})
vim.keymap.set("n", "<C-p>", function()
    telescope.git_files({ recurse_submodules = true })
end)
vim.keymap.set("n", "<leader>s", function()
    telescope.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set("n", "<leader>b", telescope.buffers, {})
vim.keymap.set("n", "<leader>h", telescope.help_tags, {})

--require('gruvbox').setup({
--    contrast = 'hard',
--	palette_overrides = {
--		gray = "#2ea542",
--	}
--})

vim.cmd('colorscheme gruvbox')


vim.g.mapleader = ' '

vim.o.background = 'dark'
vim.o.guifont = 'JetBrainsMono NFM:h8'

vim.o.tabstop = 4
vim.o.shiftwidth = 4

vim.o.number = false
vim.o.relativenumber = false
vim.o.swapfile = false

vim.o.hlsearch = false
vim.o.incsearch = true

vim.o.mouse = 'a'
vim.o.cursorline = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.pastetoggle = "<F2>"
vim.o.colorcolumn = tostring(80)

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

-- vim.cmd('set ssl')
