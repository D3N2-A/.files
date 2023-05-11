print [[
   / __ \__  // | / /__ \
  / / / //_ </  |/ /__/ /
 / /_/ /__/ / /|  // __/
/_____/____/_/ |_//____/
]]
vim.g.mapleader = " "

require("packer").startup(function(use)
	use { "wbthomason/packer.nvim" }
	use { "ellisonleao/gruvbox.nvim" }
	use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
	use('nvim-treesitter/nvim-treesitter-context')
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.1',
		requires = { { 'nvim-lua/plenary.nvim' } }
	}
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true }
	}
	use { "fatih/vim-go" }
	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v1.x',
		requires = {
			{ 'neovim/nvim-lspconfig' },    -- Required
			{ 'williamboman/mason.nvim' },  -- Optional
			{ 'williamboman/mason-lspconfig.nvim' }, -- Optional
			{ 'hrsh7th/nvim-cmp' },         -- Required
			{ 'hrsh7th/cmp-nvim-lsp' },     -- Required
			{ 'hrsh7th/cmp-buffer' },       -- Optional
			{ 'hrsh7th/cmp-path' },         -- Optional
			{ 'saadparwaiz1/cmp_luasnip' }, -- Optional
			{ 'hrsh7th/cmp-nvim-lua' },     -- Optional
			{ 'L3MON4D3/LuaSnip' },         -- Required
			{ 'rafamadriz/friendly-snippets' }, -- Optional
		},
		-- use { "akinsho/toggleterm.nvim", tag = '*' },
		use "jhlgns/naysayer88.vim",
		use "terrortylor/nvim-comment",
		use "CreaturePhil/vim-handmade-hero"
	}
	use { "mbbill/undotree" }
	use { "tpope/vim-fugitive" }
	use { "karb94/neoscroll.nvim" }
end)
require('neoscroll').setup()
-- some
vim.keymap.set("n", "<M-b>", ":Ex<CR>")

-- split screen and navigation
vim.keymap.set("n", "<leader>v", ":vsplit<CR><C-w>l", { noremap = true })
vim.keymap.set("n", "<leader>h", ":wincmd h<CR>", { noremap = true })
vim.keymap.set("n", "<leader>l", ":wincmd l<CR>", { noremap = true })

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>fr', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>f', function()
	require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
		winblend = 10,
		previewer = false,
	})
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>pf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>ps', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

-- TREESITTER
require 'nvim-treesitter.configs'.setup {
	ensure_installed = { "c", "cpp", "lua", "vim", "javascript", "typescript", "rust" },
	highlight = {
		enable = true,
	}
}

-- GRUVBOX
require("gruvbox").setup({
	contrast = "hard",
	palette_overrides = {
		gray = "#2ea542",
	}
})

-- LUALINE
require("lualine").setup {
	options = {
		icons_enabled = false,
		theme = "onedark",
		component_separators = "|",
		section_separators = "",
	},
}

-- LSP
local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
	"tsserver",
	"eslint",
})

lsp.set_preferences({
	sign_icons = {}
})

lsp.on_attach(function(client, bufnr)
	local nmap = function(keys, func, desc)
		if desc then
			desc = 'LSP: ' .. desc
		end

		vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
	end
	local opts = { buffer = bufnr, remap = false }
	vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
	nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
	nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
	nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
	nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
	nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
	nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
	nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
end)

lsp.setup()

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, {
		signs = false,
		virtual_text = true,
		underline = false,
	}
)

-- COMMENT
require("nvim_comment").setup({
	operator_mapping = "<leader>/"
})

-- TERMINAL SETUP
-- require("toggleterm").setup {
-- 	direction = "horizontal",
-- 	size = 15,
-- 	open_mapping = [[<M-j>]]
-- }

--View files
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

--AUTO FORMATTING
--vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]

-- COLORSCHEME
vim.cmd("colorscheme gruvbox")

-- Adding the same comment color in each theme
vim.cmd([[
	augroup CustomCommentCollor
		autocmd!
		autocmd VimEnter * hi Comment guifg=#2ea542
	augroup END
]])

-- highlight yanked text for 200ms using the "Visual" highlight group
vim.cmd [[
  augroup highlight_yank
  autocmd!
  au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=100})
  augroup END
]]

require("d3n2")
