return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ -- If encountering errors, see telescope-fzf-native README for installation instructions
			"nvim-telescope/telescope-fzf-native.nvim",

			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	config = function()
		require("telescope").setup({
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")

		-- The nvim-treesitter `main` branch removed the legacy parsers/configs API
		-- (ft_to_lang, configs.is_enabled, get_parser) that telescope's previewer
		-- highlighter relies on, causing "attempt to call field 'ft_to_lang'".
		--
		-- Rather than clobber telescope's highlighter outright, wrap it: prefer
		-- telescope's own implementation and only fall back to Neovim's native
		-- treesitter starter when it errors. When telescope eventually ships proper
		-- `main`-branch support, its highlighter stops erroring and this wrapper
		-- becomes a transparent pass-through instead of hiding the upstream fix.
		local putils = require("telescope.previewers.utils")
		local native_ts_highlighter = function(bufnr, ft)
			local lang = vim.treesitter.language.get_lang(ft) or ft
			return pcall(vim.treesitter.start, bufnr, lang)
		end
		if type(putils.ts_highlighter) == "function" then
			local original = putils.ts_highlighter
			putils.ts_highlighter = function(bufnr, ft, ...)
				if pcall(original, bufnr, ft, ...) then
					return true
				end
				return native_ts_highlighter(bufnr, ft)
			end
		else
			putils.ts_highlighter = native_ts_highlighter
		end

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
		vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
		vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
		vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
		vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
		vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
		vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
		vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

		vim.keymap.set("n", "<leader>sg", function()
			builtin.live_grep({
				additional_args = { "--hidden" },
			})
		end, { desc = "[S]earch by [G]rep" })

		vim.keymap.set("n", "<leader>/", function()
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, { desc = "[/] Fuzzily search in current buffer" })

		vim.keymap.set("n", "<leader>s/", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "[S]earch [/] in Open Files" })

		vim.keymap.set("n", "<leader>sn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "[S]earch [N]eovim files" })
	end,
}

-- vim: ts=2 sts=2 sw=2 noet
