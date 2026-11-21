-- rustaceanvim - rust-analyzer client and Rust tooling
-- https://github.com/mrcjkb/rustaceanvim
--
-- Replaces the plain nvim-lspconfig `rust_analyzer` setup. It starts
-- rust-analyzer itself (so the server is excluded from mason-lspconfig's
-- `automatic_enable` in nvim-lspconfig.lua) and adds what the generic LSP
-- client lacks: runnables, debuggables, macro expansion, grouped code actions
-- and a neotest adapter.
--
-- The settings are chosen for working alongside a coding agent that runs
-- `cargo` in the terminal split while the editor is open on the same checkout.

return {
	"mrcjkb/rustaceanvim",
	version = "^9", -- 9.x needs Neovim 0.12+
	lazy = false, -- a filetype plugin; it defers its own loading
	init = function()
		vim.g.rustaceanvim = {
			server = {
				on_attach = function(_, bufnr)
					local map = function(keys, args, desc)
						vim.keymap.set("n", keys, function()
							vim.cmd.RustLsp(args)
						end, { buffer = bufnr, desc = "Rust: " .. desc })
					end

					map("<leader>Rr", "runnables", "[R]unnables")
					map("<leader>Rt", "testables", "[T]estables")
					map("<leader>Rd", "debuggables", "[D]ebuggables")
					map("<leader>Rm", "expandMacro", "Expand [M]acro")
					map("<leader>Re", "explainError", "[E]xplain error")
					map("<leader>RD", "renderDiagnostic", "Render [D]iagnostic as rustc prints it")
					map("<leader>Rc", "openCargo", "Open [C]argo.toml")
					map("<leader>Rp", "parentModule", "[P]arent module")
					map("<leader>Rf", { "flyCheck", "run" }, "Re-run check ([F]lycheck)")

					-- rust-analyzer groups its code actions (e.g. every "import ..."
					-- candidate under one entry), which `vim.lsp.buf.code_action`
					-- cannot show. This runs after the LspAttach autocommand in
					-- nvim-lspconfig.lua, so it wins for Rust buffers.
					map("<leader>ca", "codeAction", "[C]ode [A]ction")
				end,
				default_settings = {
					["rust-analyzer"] = {
						cargo = {
							-- Check into `target/rust-analyzer` instead of `target`.
							-- Cargo takes an exclusive lock on the build directory, so
							-- with a shared one every check-on-save stalls the agent's
							-- `cargo build`/`cargo test` behind "Blocking waiting for
							-- file lock on build directory", and the reverse. A separate
							-- directory also keeps the two apart when the agent runs a
							-- different toolchain in a container. The cost is disk
							-- space: dependencies are compiled once per directory.
							targetDir = true,
						},
						check = {
							-- Diagnostics come from clippy rather than `cargo check`, so
							-- workspace lints (`unwrap_used`, `expect_used`, `panic`, ...)
							-- show up while reviewing, not later in CI.
							command = "clippy",
						},
					},
				},
			},
			dap = {
				-- Do not build every debuggable when the server attaches: that is a
				-- `cargo build` in the shared `target` directory, on each attach,
				-- for something only needed when a debug session starts.
				-- `:RustLsp debuggables` (<leader>Rd) builds the one that is picked.
				autoload_configurations = false,
			},
		}

		-- rust-analyzer runs clippy when a buffer is saved, not when it is reloaded.
		-- When an agent rewrites a file from the terminal, the diagnostics would go
		-- on describing the code as it was before the edit, and those are the
		-- diagnostics Claude Code reads back through claudecode.nvim. Ask for a
		-- fresh check whenever a Rust buffer is reloaded from disk. (The server
		-- coalesces a burst of these into one run.)
		vim.api.nvim_create_autocmd("FileChangedShellPost", {
			desc = "Re-run the Rust check after a buffer is reloaded from disk",
			group = vim.api.nvim_create_augroup("prinsmike-rust-recheck", { clear = true }),
			pattern = "*.rs",
			callback = function(args)
				for _, client in ipairs(vim.lsp.get_clients({ bufnr = args.buf, name = "rust-analyzer" })) do
					client:notify("rust-analyzer/runFlycheck", {
						textDocument = { uri = vim.uri_from_bufnr(args.buf) },
					})
				end
			end,
		})
	end,
}
