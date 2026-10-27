-- mdkite.nvim (formerly markdown-preview.nvim) - live Markdown preview in the
-- browser, with Mermaid, KaTeX and scroll sync. Pure Lua server, no Node.js or
-- npm required.
-- https://github.com/selimacerbas/mdkite.nvim

return {
	"selimacerbas/mdkite.nvim",
	dependencies = { "selimacerbas/kitehost.nvim" },
	ft = { "markdown", "mermaid" },
	cmd = { "MdKite" },
	keys = {
		{ "<leader>mp", "<cmd>MdKite start<cr>", desc = "Start [P]review" },
		{ "<leader>mr", "<cmd>MdKite refresh<cr>", desc = "[R]efresh preview" },
		{ "<leader>ms", "<cmd>MdKite stop<cr>", desc = "[S]top preview" },
	},
	opts = {
		instance_mode = "takeover", -- one shared browser tab across Neovim instances
		port = 0, -- 0 = auto (8421 in takeover mode)
		open_browser = true,
		default_theme = "dark",
		debounce_ms = 300,
		scroll_sync = true,
	},
	config = function(_, opts)
		require("mdkite").setup(opts)
	end,
}
