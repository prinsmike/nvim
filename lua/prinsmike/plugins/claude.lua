-- lua/prinsmike/plugins/claude.lua
-- This file configures the claude.vim plugin for AI pair programming
return {
	"pasky/claude.vim",
	-- Configure the plugin
	config = function()
		-- API key should be set in your environment variables for security
		vim.g.claude_api_key = os.getenv("ANTHROPIC_API_KEY")

		-- Configure keymaps
		vim.g.claude_map_implement = "<leader>aci"
		vim.g.claude_map_open_chat = "<leader>acc"
		vim.g.claude_map_send_chat_message = "<C-]>"
		vim.g.claude_map_cancel_response = "<leader>acx"
	end,
}
