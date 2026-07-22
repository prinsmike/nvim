return { -- LSP Configuration & Plugins
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				-- Jump to the definition of the word under the cursor.
				--  To jump back, press <C-t>.
				map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

				-- Find references for the word under the cursor.
				map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

				-- Jump to the implementation of the word under the cursor.
				map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

				-- Jump to the type of the word under the cursor.
				map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

				-- Fuzzy find all the symbols in the current document.
				map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

				-- Fuzzy find all the symbols in the current workspace.
				map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

				-- Rename the variable under your cursor.
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

				-- Execute a code action, usually your cursor needs to be on top of an error
				-- or a suggestion from your LSP for this to activate.
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

				-- Opens a popup that displays documentation about the word under your cursor
				map("K", vim.lsp.buf.hover, "Hover Documentation")

				-- WARN: This is not Goto Definition, this is Goto Declaration.
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

				-- Highlight references of the word under the cursor when it rests
				-- there for a little while. When you move your cursor, the highlights
				-- will be cleared (the second autocommand).
				local client = vim.lsp.get_client_by_id(event.data.client_id)

				-- Enable inlay hints (e.g. gopls parameter names / inferred
				-- types) if the server supports them, with a toggle.
				if client and client:supports_method("textDocument/inlayHint") then
					vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
					map("<leader>uh", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }), { bufnr = event.buf })
					end, "Toggle Inlay [H]ints")
				end

				if client and client.server_capabilities.documentHighlightProvider then
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						callback = vim.lsp.buf.clear_references,
					})
				end
			end,
		})

		-- LSP servers and clients are able to communicate to each other what features
		-- they support. By default, Neovim doesn't support everything that is in the
		-- LSP specification. When you add nvim-cmp, luasnip, etc. Neovim now has
		-- *more* capabilities. So, we create new capabilities with nvim cmp, and then
		-- broadcast that to the servers.
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		-- Broadcast the nvim-cmp capabilities to every server. nvim-lspconfig ships
		-- the base `lsp/<server>.lua` definitions (cmd, root markers, filetypes); we
		-- only layer our overrides on top via `vim.lsp.config`, and let
		-- mason-lspconfig's `automatic_enable` call `vim.lsp.enable` for each
		-- installed server. (The legacy `handlers`/`lspconfig[...].setup` API was
		-- removed in mason-lspconfig v2.)
		vim.lsp.config("*", { capabilities = capabilities })

		-- Per-server overrides.
		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					completion = {
						callSnippet = "Replace",
					},
					workspace = {
						-- Make the language server aware of the Neovim runtime files
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
						},
						checkThirdParty = false,
					},
					diagnostics = {
						-- Add "vim" as a global to avoid undefined global warnings
						globals = { "vim" },
					},
				},
			},
		})

		vim.lsp.config("gopls", {
			settings = {
				gopls = {
					gofumpt = true,
					staticcheck = true,
					usePlaceholders = true,
					analyses = {
						unusedparams = true,
						shadow = true,
						nilness = true,
						unusedwrite = true,
						useany = true,
					},
					hints = {
						assignVariableTypes = true,
						compositeLiteralFields = true,
						compositeLiteralTypes = true,
						constantValues = true,
						functionTypeParameters = true,
						parameterNames = true,
						rangeVariableTypes = true,
					},
					codelenses = {
						gc_details = true,
						generate = true,
						regenerate_cgo = true,
						test = true,
						tidy = true,
						upgrade_dependency = true,
						vendor = true,
					},
				},
			},
		})

		-- Language servers to install and enable.
		local servers = { "gopls", "pyright", "rust_analyzer", "lua_ls" }

		require("mason").setup()

		-- You can add other tools here that you want Mason to install
		-- for you, so that they are available from within Neovim.
		local ensure_installed = vim.list_extend(vim.deepcopy(servers), {
			"stylua", -- Used to format Lua code
			"goimports", -- Used to organize Go imports
			"gofumpt", -- Used to format Go code (stricter than gofmt)
			"black", -- Used to format Python code
			-- rustfmt is a rustup component, not a Mason package (Mason removed it),
			-- so install it with `rustup component add rustfmt`. conform picks it up
			-- from PATH.
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		-- `automatic_enable` (default true) calls `vim.lsp.enable` for each server
		-- Mason installs, applying the `vim.lsp.config` overrides above.
		require("mason-lspconfig").setup({
			ensure_installed = {}, -- installs are driven by mason-tool-installer above
			automatic_enable = true,
		})
	end,
}
