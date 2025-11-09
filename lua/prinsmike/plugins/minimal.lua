-- Minimal colorscheme based on principles from https://tonsky.me/blog/syntax-highlighting/
-- Uses only 4-5 colors strategically:
-- - Green for strings/numbers
-- - Purple for constants
-- - Yellow for comments (prominent, not grayed out)
-- - Blue for top-level definitions
-- - Gray for punctuation
-- Keywords, variables, and function calls use default text color

return {
	"minimal-colorscheme",
	dir = vim.fn.stdpath("config"),
	priority = 1000,
	config = function()
		-- Detect if terminal supports true color
		vim.opt.termguicolors = true

		-- Clear existing highlights
		vim.cmd("highlight clear")
		if vim.fn.exists("syntax_on") then
			vim.cmd("syntax reset")
		end

		vim.g.colors_name = "minimal"

		-- Define color palette (dark mode)
		local colors = {
			-- Background and foreground
			bg = "#1a1a1a",
			fg = "#e0e0e0",

			-- Syntax colors (only 5 meaningful colors, adjusted for dark background)
			green = "#66d9a9", -- Strings, numbers
			purple = "#b794f4", -- Constants
			yellow = "#f0c674", -- Comments (prominent)
			blue = "#6cb6ff", -- Top-level definitions
			gray = "#808080", -- Punctuation, delimiters

			-- UI colors
			ui_gray = "#2a2a2a",
			ui_border = "#3a3a3a",
			selection = "#264f78",
			visual = "#3e4451",
		}

		-- Helper function to set highlights
		local function hl(group, opts)
			vim.api.nvim_set_hl(0, group, opts)
		end

		-- Base colors
		hl("Normal", { fg = colors.fg, bg = colors.bg })
		hl("NormalFloat", { fg = colors.fg, bg = colors.bg })
		hl("Comment", { fg = colors.yellow, bold = true })

		-- Strings and numbers
		hl("String", { fg = colors.green })
		hl("Character", { fg = colors.green })
		hl("Number", { fg = colors.green })
		hl("Float", { fg = colors.green })
		hl("Boolean", { fg = colors.purple })

		-- Constants
		hl("Constant", { fg = colors.purple })

		-- Top-level definitions (functions, classes)
		hl("Function", { fg = colors.blue })
		hl("@function", { fg = colors.blue })
		hl("@function.call", { fg = colors.fg }) -- Function calls are NOT highlighted
		hl("@method", { fg = colors.blue })
		hl("@method.call", { fg = colors.fg }) -- Method calls are NOT highlighted

		-- Keywords, conditionals, etc. - use default text color (not highlighted)
		hl("Keyword", { fg = colors.fg })
		hl("Conditional", { fg = colors.fg })
		hl("Repeat", { fg = colors.fg })
		hl("Statement", { fg = colors.fg })
		hl("Label", { fg = colors.fg })
		hl("Operator", { fg = colors.gray })
		hl("Exception", { fg = colors.fg })
		hl("PreProc", { fg = colors.fg })
		hl("Include", { fg = colors.fg })
		hl("Define", { fg = colors.fg })
		hl("Macro", { fg = colors.fg })
		hl("Type", { fg = colors.fg })
		hl("StorageClass", { fg = colors.fg })
		hl("Structure", { fg = colors.fg })
		hl("Typedef", { fg = colors.fg })

		-- Variables - use default text color (not highlighted)
		hl("Identifier", { fg = colors.fg })
		hl("@variable", { fg = colors.fg })
		hl("@parameter", { fg = colors.fg })
		hl("@property", { fg = colors.fg })
		hl("@field", { fg = colors.fg })

		-- Punctuation and delimiters - grayed out
		hl("Delimiter", { fg = colors.gray })
		hl("@punctuation.delimiter", { fg = colors.gray })
		hl("@punctuation.bracket", { fg = colors.gray })
		hl("@punctuation.special", { fg = colors.gray })

		-- Special elements
		hl("Special", { fg = colors.fg })
		hl("SpecialChar", { fg = colors.green })
		hl("Tag", { fg = colors.fg })
		hl("SpecialComment", { fg = colors.yellow, bold = true })
		hl("Debug", { fg = colors.fg })

		-- UI elements
		hl("LineNr", { fg = colors.gray })
		hl("CursorLineNr", { fg = colors.fg, bold = true })
		hl("CursorLine", { bg = colors.ui_gray })
		hl("ColorColumn", { bg = colors.ui_gray })
		hl("SignColumn", { bg = colors.bg })
		hl("Folded", { fg = colors.gray, bg = colors.ui_gray })
		hl("FoldColumn", { fg = colors.gray, bg = colors.bg })

		-- Search and selection
		hl("Search", { bg = colors.selection })
		hl("IncSearch", { bg = colors.yellow, fg = colors.bg })
		hl("Visual", { bg = colors.visual })
		hl("VisualNOS", { bg = colors.visual })

		-- Diff colors
		hl("DiffAdd", { bg = "#2a4a2a" })
		hl("DiffChange", { bg = "#4a4a2a" })
		hl("DiffDelete", { bg = "#4a2a2a" })
		hl("DiffText", { bg = "#4a3a2a" })

		-- Statusline
		hl("StatusLine", { fg = colors.fg, bg = colors.ui_gray })
		hl("StatusLineNC", { fg = colors.gray, bg = colors.ui_gray })

		-- Messages and errors
		hl("ErrorMsg", { fg = "#ff6b6b", bold = true })
		hl("WarningMsg", { fg = "#f0c674", bold = true })
		hl("ModeMsg", { fg = colors.fg, bold = true })
		hl("MoreMsg", { fg = colors.blue })
		hl("Question", { fg = colors.blue })

		-- Diagnostics
		hl("DiagnosticError", { fg = "#ff6b6b" })
		hl("DiagnosticWarn", { fg = "#f0c674" })
		hl("DiagnosticInfo", { fg = colors.blue })
		hl("DiagnosticHint", { fg = colors.gray })

		-- Spelling
		hl("SpellBad", { sp = "#ff6b6b", undercurl = true })
		hl("SpellCap", { sp = colors.blue, undercurl = true })
		hl("SpellRare", { sp = colors.purple, undercurl = true })
		hl("SpellLocal", { sp = colors.green, undercurl = true })

		-- LSP semantic tokens - keep minimal
		hl("@lsp.type.variable", { fg = colors.fg })
		hl("@lsp.type.parameter", { fg = colors.fg })
		hl("@lsp.type.property", { fg = colors.fg })
		hl("@lsp.type.function", { fg = colors.blue })
		hl("@lsp.type.method", { fg = colors.blue })
		hl("@lsp.type.class", { fg = colors.blue })
		hl("@lsp.type.namespace", { fg = colors.fg })

		-- Telescope
		hl("TelescopeBorder", { fg = colors.ui_border })
		hl("TelescopePromptBorder", { fg = colors.ui_border })
		hl("TelescopeResultsBorder", { fg = colors.ui_border })
		hl("TelescopePreviewBorder", { fg = colors.ui_border })
	end,
}
