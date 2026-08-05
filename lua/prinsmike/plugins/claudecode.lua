-- claudecode.nvim - Neovim integration for Claude Code
-- https://github.com/coder/claudecode.nvim

return {
	"coder/claudecode.nvim",
	dependencies = { "folke/snacks.nvim" },
	config = true,
	keys = {
		{ "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle [C]laude Code" },
		{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "[F]ocus Claude Code" },
		{ "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "[S]end to Claude Code" },
		{ "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude [M]odel" },
		{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "[A]ccept Claude diff" },
		{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "[D]eny Claude diff" },
	},
	opts = {
		-- Server Settings
		auto_start = true,
		log_level = "info",

		-- Launch Claude Code through the in-repo wrapper. It runs the agent in a
		-- container scoped to the current repository when that repository asks for
		-- one (a `.claude-container` file, or CLAUDE_CONTAINER in the environment),
		-- and otherwise execs the host installation unchanged.
		-- See docs/claude-container.md.
		terminal_cmd = vim.fs.joinpath(vim.fn.stdpath("config"), "scripts", "claude-container"),

		-- Terminal Display
		terminal = {
			split_side = "right",
			split_width_percentage = 0.30,
			auto_close = true,
		},

		-- Diff Handling
		diff_opts = {
			auto_close_on_accept = true,
			vertical_split = true,
		},

		-- Use git repository root as working directory
		git_repo_cwd = true,
	},
}
