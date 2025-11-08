---
description: List all custom keybindings in the configuration
---

You are helping the user find keybindings in this Neovim configuration.

Search through the following files and provide a comprehensive list of all keybindings:

1. `init.lua` - General keybindings
2. `lua/prinsmike/plugins/telescope.lua` - Telescope keybindings
3. `lua/prinsmike/plugins/nvim-lspconfig.lua` - LSP keybindings (in LspAttach autocmd)
4. `lua/prinsmike/plugins/gitsigns.lua` - Git keybindings
5. Any other plugin files that define keybindings

Format the output as a markdown table with columns:
- Key
- Mode (n/v/i)
- Description
- File Location

Group by category (General, LSP, Telescope, Git, etc.)

Note: Leader key is Space.
