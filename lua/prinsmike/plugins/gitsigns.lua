-- The revision `<leader>vB` moved the diff base to, or nil when diffing against
-- the index. Shared by every buffer, because the base is changed globally.
local review_base = nil

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
			map("n", "<leader>vS", gitsigns.stage_buffer, { desc = "git stage buffer" })
			map("n", "<leader>vR", gitsigns.reset_buffer, { desc = "git reset buffer" })
			map("n", "<leader>vhp", gitsigns.preview_hunk, { desc = "git preview hunk" })
			map("n", "<leader>vb", gitsigns.blame_line, { desc = "git blame line" })
			map("n", "<leader>vd", gitsigns.diffthis, { desc = "git diff against index" })
			map("n", "<leader>vD", function()
				gitsigns.diffthis("@")
			end, { desc = "git diff against last commit" })
			-- Review a whole branch, e.g. one an agent wrote. `<leader>vB` moves
			-- the diff base of every buffer to where the branch left the default
			-- branch, so the signs, the hunk motions and the hunk preview cover
			-- all of its commits and not only what is uncommitted. Press it
			-- again to go back to the index. `<leader>vq` lists every hunk
			-- against the current base in the quickfix window, across all
			-- changed files, which makes a reading list for the review.
			map("n", "<leader>vB", function()
				if review_base then
					review_base = nil
					gitsigns.reset_base(true)
					vim.notify("gitsigns: diffing against the index")
					return
				end
				local root = vim.fs.root(bufnr, ".git") or vim.uv.cwd()
				for _, ref in ipairs({ "origin/HEAD", "main", "master" }) do
					local res = vim.system({ "git", "merge-base", "HEAD", ref }, { cwd = root, text = true }):wait()
					if res.code == 0 then
						review_base = vim.trim(res.stdout)
						gitsigns.change_base(review_base, true)
						vim.notify(("gitsigns: diffing against %s (merge base with %s)"):format(review_base:sub(1, 8), ref))
						return
					end
				end
				vim.notify("gitsigns: no origin/HEAD, main or master to compare with", vim.log.levels.WARN)
			end, { desc = "git toggle diff against branch base (review)" })
			map("n", "<leader>vq", function()
				gitsigns.setqflist("all")
			end, { desc = "git all changes to quickfix" })
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
