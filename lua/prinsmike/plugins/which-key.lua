return {
	"folke/which-key.nvim",
	event = "VimEnter",
	config = function()
		require("which-key").setup()
		require("which-key").add({
			{ "<leader>a", group = "[A]I" },
			{ "<leader>a_", hidden = true },
			{ "<leader>c", group = "[C]ode" },
			{ "<leader>c_", hidden = true },
			{ "<leader>d", group = "[D]ebugging" },
			{ "<leader>d_", hidden = true },
			{ "<leader>wf", group = "[F]ile Tree" },
			{ "<leader>wf_", hidden = true },
			{ "<leader>p", group = "[P]aperwork" },
			{ "<leader>p_", hidden = true },
			{ "<leader>r", group = "[R]ename" },
			{ "<leader>r_", hidden = true },
			{ "<leader>s", group = "[S]earch" },
			{ "<leader>s_", hidden = true },
			{ "<leader>t", group = "[T]erminal" },
			{ "<leader>t_", hidden = true },
			{ "<leader>v", group = "[V]ersion Control" },
			{ "<leader>v_", hidden = true },
			{ "<leader>vh", group = "[h]unk" },
			{ "<leader>vh_", hidden = true },
			{ "<leader>vt", group = "[t]oggle" },
			{ "<leader>vt_", hidden = true },
			{ "<leader>w", group = "[W]orkspace" },
			{ "<leader>w_", hidden = true },
		})
	end,
}

-- vim: ts=2 sts=2 sw=2 et
