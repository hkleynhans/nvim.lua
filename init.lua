-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.o.hlsearch = false
vim.o.incsearch = true

vim.o.mouse = 'a'
vim.o.cursorline = true

vim.o.ignorecase = true
vim.o.smartcase = true

-- vim.o.pastetoggle = "<F2>"
vim.o.colorcolumn = tostring(80)

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

-- Setup lazy.nvim
require("lazy").setup({
  --opts = {
  --      rocks{ 
  --      	enabled = false,
  --      	hererocks = false,
  --      },
  --},
  rocks = {
    enabled = false,
    hererocks = false,
  },
  spec = {
     -- Requires luarocks which does not compile on Windows.
     { "editorconfig/editorconfig-vim", name="editorconfig" },
     { "morhetz/gruvbox", name="gruvbox" },
     -- Telescope
     {
	'nvim-telescope/telescope.nvim',
	dependencies = {
		"nvim-lua/plenary.nvim",
	},

	config = function()
		require('telescope').setup({
			pickers = {
				git_files = {
					recurse_submodules = true,
				},
			},
		})

		local builtin = require('telescope.builtin')
		vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
		vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
		vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
		vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
		vim.keymap.set('n', '<C-p>', builtin.git_files, {})
	end,
    },
    -- TreeSitter
    {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"c", "cpp", "lua",
				"javascript", "typescript", "jsdoc", "rust",
			},

			sync_install = false,
			auto_install = false,
			-- Do we want auto-indent here?
			indent = {
				enable = true,
			},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
		})
	end,
    },
    -- LSP
    {
       "neovim/nvim-lspconfig",
       dependencies = {
       	"williamboman/mason.nvim",
       	"williamboman/mason-lspconfig.nvim",
       	"hrsh7th/cmp-nvim-lsp",
       	"hrsh7th/cmp-buffer",
       	"hrsh7th/cmp-path",
       	"hrsh7th/cmp-cmdline",
       	"hrsh7th/nvim-cmp",
       	"j-hui/fidget.nvim",
       },

       config = function()
           local cmp = require('cmp')
           local cmp_lsp = require('cmp_nvim_lsp')
           local capabilities = vim.tbl_deep_extend(
           	"force",
           	{},
           	vim.lsp.protocol.make_client_capabilities(),
           	cmp_lsp.default_capabilities())
           require('fidget').setup({})
           require('mason').setup()
           require('mason-lspconfig').setup({
               ensure_installed = {
               	'clangd',
               	'lua_ls',
		'rust_analyzer',
               },
               handlers = {
   	        function(server_name) -- default handler
   	        	require('lspconfig')[server_name].setup({
   	        		capabilities = capabilities
   	        	})
   	        end,

   	        ["lua_ls"] = function()
   	       	    local lspconfig = require('lspconfig')
   	    	    lspconfig.lua_ls.setup({
   	            	    capabilities = capabilities,
   	            	    settings = {
   	            	    	Lua = {
   	            	    		runtime = { version = 'Lua 5.1' },
   	            	    		diagnostics = {
   	            	    			globals = { 'vim', 'it', 'describe', 'before_each', 'after_each' },
   	            	    		},
   	            	    	},
   	            	    },
   	    	    })
   	        end,
   	    },
   	})

   	local cmp_select = { behavior = cmp.SelectBehavior.Select }

   	cmp.setup({
   		mapping = cmp.mapping.preset.insert({
   			['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
   			['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
   			['<C-y>'] = cmp.mapping.confirm({ select = true }),
   			["<C-Space>"] = cmp.mapping.complete(),
   		}),
   		sources = cmp.config.sources({
   			{ name = 'nvim_lsp' },
   		}, {
   				{ name = 'buffer' },
   			})
   	})

   	vim.diagnostic.config({
   		-- update_in_insert = true,
   		float = {
   			focusable = false,
   			style = "minimal",
   			border = "rounded",
   			source = "always",
   			header = "",
   			prefix = "",
   		},
   	})
       end,
   },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
  colorscheme = "habamax",

})
