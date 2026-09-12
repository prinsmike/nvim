-- markdown-preview.nvim - live Markdown preview in the browser, with Mermaid,
-- KaTeX and scroll sync. Pure Lua server, no Node.js or npm required.
-- https://github.com/selimacerbas/markdown-preview.nvim

return {
	"selimacerbas/markdown-preview.nvim",
	dependencies = { "selimacerbas/live-server.nvim" },
	ft = { "markdown", "mermaid" },
	cmd = { "MarkdownPreview", "MarkdownPreviewRefresh", "MarkdownPreviewStop" },
	keys = {
		{ "<leader>mp", "<cmd>MarkdownPreview<cr>", desc = "Start [P]review" },
		{ "<leader>mr", "<cmd>MarkdownPreviewRefresh<cr>", desc = "[R]efresh preview" },
		{ "<leader>ms", "<cmd>MarkdownPreviewStop<cr>", desc = "[S]top preview" },
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
		require("markdown_preview").setup(opts)
	end,
}
