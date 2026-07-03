return { -- Test runner: run/debug tests from the editor with inline results
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",

		-- Go adapter. Uses the `go test` runner by default and drives
		-- nvim-dap-go for debugging (dap_mode = "dap-go").
		"fredrikaverpil/neotest-golang",
	},
	keys = {
		{
			"<leader>Tr",
			function()
				require("neotest").run.run()
			end,
			desc = "[T]est: [R]un nearest",
		},
		{
			"<leader>Tf",
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			desc = "[T]est: run [F]ile",
		},
		{
			"<leader>Ta",
			function()
				require("neotest").run.run(vim.uv.cwd())
			end,
			desc = "[T]est: run [A]ll (project)",
		},
		{
			"<leader>Td",
			function()
				require("neotest").run.run({ strategy = "dap" })
			end,
			desc = "[T]est: [D]ebug nearest (dap)",
		},
		{
			"<leader>TS",
			function()
				require("neotest").run.stop()
			end,
			desc = "[T]est: [S]top",
		},
		{
			"<leader>Ts",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "[T]est: toggle [S]ummary",
		},
		{
			"<leader>To",
			function()
				require("neotest").output.open({ enter = true, auto_close = true })
			end,
			desc = "[T]est: show [O]utput",
		},
		{
			"<leader>TO",
			function()
				require("neotest").output_panel.toggle()
			end,
			desc = "[T]est: toggle [O]utput panel",
		},
		{
			"<leader>Tw",
			function()
				require("neotest").watch.toggle(vim.fn.expand("%"))
			end,
			desc = "[T]est: [W]atch file",
		},
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-golang")({
					dap_mode = "dap-go",
				}),
			},
		})
	end,
}
