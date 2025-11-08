---
description: Add a new formatter to conform.nvim
---

You are helping add a new formatter to this Neovim configuration.

Follow these steps:

1. Ask the user which language/formatter they want to add
2. Find the Mason package name for the formatter (if available via Mason)
3. Add the formatter to `formatters_by_ft` table in `lua/prinsmike/plugins/conform.lua` (around line 23-25)
4. If the formatter is available via Mason, add it to the `ensure_installed` list in `lua/prinsmike/plugins/nvim-lspconfig.lua`
5. Add any formatter-specific configuration to the `formatters` table in conform.lua if needed
6. Add an entry to CHANGELOG.md under `[Unreleased]` > `### Added`
7. Show the user what was changed and suggest they:
   - Restart Neovim or run `:Lazy reload`
   - Test formatting with `<leader>f` in a file of that type

Note: Format-on-save is enabled by default with a 500ms timeout.
