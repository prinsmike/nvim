return {
	"lewis6991/gitsigns.nvim",
	opts = {
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")

			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end

			map("n", "<leader>v.", function()
				if vim.wo.diff then
					vim.cmd.normal({ "<leader>v.", bang = true })
				else
					gitsigns.nav_hunk("next")
				end
			end, { desc = "Jump to next git change" })

			map("n", "<leader>v,", function()
				if vim.wo.diff then
					vim.cmd.normal({ "<leader>v,", bang = true })
				else
					gitsigns.nav_hunk("prev")
				end
			end, { desc = "Jump to previous git change" })

			map("v", "<leader>vhs", function()
				gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "stage git hunk" })

			map("v", "<leader>vhr", function()
				gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "reset git hunk" })

			map("n", "<leader>vhs", gitsigns.stage_hunk, { desc = "git stage hunk" })
			map("n", "<leader>vhr", gitsigns.reset_hunk, { desc = "git reset hunk" })
			map("n", "<leader>vhu", gitsigns.undo_stage_hunk, { desc = "git undo stage hunk" })
			map("n", "<leader>vS", gitsigns.stage_buffer, { desc = "git stage buffer" })
			map("n", "<leader>vR", gitsigns.reset_buffer, { desc = "git reset buffer" })
			map("n", "<leader>vhp", gitsigns.preview_hunk, { desc = "git preview hunk" })
			map("n", "<leader>vb", gitsigns.blame_line, { desc = "git blame line" })
			map("n", "<leader>vd", gitsigns.diffthis, { desc = "git diff against index" })
			map("n", "<leader>vD", function()
				gitsigns.diffthis("@")
			end, { desc = "git diff against last commit" })
			map("n", "<leader>vtb", gitsigns.toggle_current_line_blame, { desc = "toggle git show blame line" })
			map("n", "<leader>vtd", gitsigns.toggle_deleted, { desc = "toggle git show deleted" })
		end,
		signcolumn = true,
		numhl = true,
		linehl = false,
		word_diff = false,
		current_line_blame = false,
		signs_staged_enable = true,
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┊" },
		},
		signs_staged = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┊" },
		},
	},
}

-- vim: ts=2 sts=2 sw=2 et
