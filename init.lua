-- # Neovim Configuration

-- ## Vim options

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true
vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300 -- Displays which-key popup sooner
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true --  See `:help 'list'` and `:help 'listchars'`
vim.opt.listchars = { tab = "┊ ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split" -- Preview substitutions live, as you type!
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.hlsearch = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.bo.softtabstop = 2
vim.opt.expandtab = false
vim.opt.spelllang = "en_gb"

-- ## keymaps

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("t", "<C-x>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
vim.keymap.set("n", "<C-down>", "<C-w>-", { desc = "Reduce window height" })
vim.keymap.set("n", "<C-up>", "<C-w>+", { desc = "Increase window height" })
vim.keymap.set("n", "<C-left>", "<C-w><", { desc = "Reduce window width" })
vim.keymap.set("n", "<C-right>", "<C-w>>", { desc = "Increase window width" })
vim.keymap.set("i", "<C-h>", "<Left>", { desc = "Move cursor to the left in insert mode" })
vim.keymap.set("i", "<C-l>", "<Right>", { desc = "Move cursor to the right in insert mode" })
vim.keymap.set("i", "<C-j>", "<Down>", { desc = "Move cursor down in insert mode" })
vim.keymap.set("i", "<C-k>", "<Up>", { desc = "Move cursor up in insert mode" })
vim.keymap.set("n", "<leader>ts", "<cmd>20sp | term<CR>", { desc = "Open [T]erminal in [S]plit window" })
vim.keymap.set("n", "<leader>tv", "<cmd>vsp | term<CR>", { desc = "Open [T]erminal in [V]ertically split window" })
vim.keymap.set("n", "<leader>tt", "<cmd>tabnew | term<CR>", { desc = "Open [T]erminal in [T]ab" })
vim.keymap.set("n", "<leader>wp", "<cmd>tabprev<CR>", { desc = "Move focus to previous tab" })
vim.keymap.set("n", "<leader>wn", "<cmd>tabnext<CR>", { desc = "Move focus to next tab" })
vim.keymap.set("n", "<leader>ps", ":set spell!<CR>", { desc = "Toggle spell check" })

-- ### Set up spell checking for markdown files with British English
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.opt_local.spell = true
		vim.opt_local.spelllang = "en_gb"
	end,
})

-- ### Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Install lazy.nvim plugin manager.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Install and configure plugins
require("lazy").setup({
	"tpope/vim-sleuth",
	{ "numToStr/Comment.nvim", opts = {} },
	require("prinsmike.plugins.gitsigns"),
	require("prinsmike.plugins.which-key"),
	require("prinsmike.plugins.telescope"),
	require("prinsmike.plugins.nvim-lspconfig"),
	require("prinsmike.plugins.conform"),
	require("prinsmike.plugins.nvim-cmp"),
	require("prinsmike.plugins.minimal"),
	require("prinsmike.plugins.todo-comments"),
	require("prinsmike.plugins.mini"),
	require("prinsmike.plugins.treesitter"),
	require("prinsmike.plugins.nvim-tree"),
	require("prinsmike.plugins.nvim-autopairs"),
	require("prinsmike.plugins.indent-blankline"),
	require("prinsmike.plugins.claudecode"),
}, {
	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})

-- vim: ts=2 sts=2 sw=2 noet
