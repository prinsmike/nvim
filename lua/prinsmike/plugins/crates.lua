-- crates.nvim - crate versions, features and updates inside Cargo.toml
-- https://github.com/saecki/crates.nvim
--
-- Shows the newest matching version next to each dependency and marks ones
-- that are outdated or yanked, which is the quickest check on a dependency an
-- agent added from memory. It looks the crates up on crates.io.

return {
	"saecki/crates.nvim",
	tag = "stable",
	event = { "BufRead Cargo.toml" },
	opts = {
		-- Run as an in-process language server, so the ordinary LSP keymaps work
		-- in Cargo.toml: `K` for versions and features, `<leader>ca` to upgrade a
		-- crate, and completion of names, versions and features through nvim-cmp.
		lsp = {
			enabled = true,
			actions = true,
			completion = true,
			hover = true,
		},
	},
}
