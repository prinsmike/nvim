return { -- Highlight, edit, and navigate code
	"nvim-treesitter/nvim-treesitter",
	branch = "main", -- the `master` branch does not support Neovim 0.12+
	lazy = false, -- main branch does not support lazy-loading
	build = ":TSUpdate",
	config = function()
		-- Install parsers (async; no-op if already installed)
		require("nvim-treesitter").install({
			"bash",
			"c",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"vim",
			"vimdoc",
		})

		-- Enable highlighting and indentation per-buffer. `vim.treesitter.start`
		-- detects the language from the filetype and errors if no parser is
		-- installed, so we guard it with pcall.
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("prinsmike_treesitter", { clear = true }),
			callback = function(args)
				if pcall(vim.treesitter.start, args.buf) then
					vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})
	end,
}
