---
description: Add a new LSP server to the configuration
---

You are helping add a new LSP server to this Neovim configuration.

Follow these steps:

1. Ask the user which language/LSP server they want to add
2. Find the Mason package name for the LSP server
3. Add the server name to the `servers` table in `lua/prinsmike/plugins/nvim-lspconfig.lua` (around line 77-92)
4. If the server needs special configuration, add it to the `server_settings` table
5. Add an entry to CHANGELOG.md under `[Unreleased]` > `### Added`
6. Show the user what was changed and suggest they:
   - Restart Neovim
   - Run `:Mason` to verify the server is installed
   - Open a file of that language type to test

The servers are auto-installed by Mason when added to the list.
