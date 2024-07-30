return {
	"mfussenegger/nvim-dap",
	keys = {
		{
			"<leader>db",
			"<cmd> DapToggleBreakpoint <CR>",
			mode = "",
			desc = "Add [D]ebugger [B]reakpoint on current line",
		},
		{
			"<leader>dus",
			function()
				local widgets = require("dap.ui.widgets")
				local sidebar = widgets.sidebar(widgets.scopes)
				sidebar.open()
			end,
			mode = "",
			desc = "Open [D]eb[u]gger [S]idebar",
		},
	},
}
