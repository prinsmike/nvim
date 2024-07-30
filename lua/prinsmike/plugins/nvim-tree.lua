return {
	"nvim-tree/nvim-tree.lua",
	cmd = { "NvimTreeToggle", "NvimTreeFocus" },
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = function()
		return require("prinsmike.configs.nvim-tree")
	end,
	config = function(_, opts)
		require("nvim-tree").setup(opts)
	end,
	keys = {
		{
			"<leader>wft",
			"<cmd>NvimTreeToggle<CR>",
			mode = "n",
			desc = "Toggle [W]orkspace [F]ile Tree [T]oggle",
		},
		{
			"<leader>wff",
			"<cmd>NvimTreeFocus<CR>",
			mode = "n",
			desc = "[W]orkspace [F]ile Tree [F]ocus",
		},
	},
}
