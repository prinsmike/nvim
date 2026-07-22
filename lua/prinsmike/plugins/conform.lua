return { -- Autoformat
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = "",
			desc = "[F]ormat buffer",
		},
	},
	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
			local disable_filetypes = { c = true, cpp = true }
			return {
				timeout_ms = 500,
				lsp_format = disable_filetypes[vim.bo[bufnr].filetype] and "never" or "fallback",
			}
		end,
		formatters_by_ft = {
			lua = { "stylua" },
			go = { "goimports", "gofumpt" },
			python = { "black" },
			rust = { "rustfmt" }, -- from rustup (`rustup component add rustfmt`), not Mason
		},
	},
}
