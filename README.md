# prinsmike's Neovim Configuration

This repository contains a customized Neovim setup, crafted to enhance the editing experience with a carefully curated selection of plugins and tailored settings. It's designed to provide a powerful, efficient, and user-friendly environment for coding and text editing.

## Structure

The configuration is organized as follows:

- `init.lua`: The main configuration file that Neovim loads on startup.
- `lazy-lock.json`: Lock file for the Lazy plugin manager.
- `lua/prinsmike/`: Directory containing custom Lua modules.
  - `configs/`: Specific configurations for plugins.
  - `plugins/`: Plugin definitions and settings.

## Features

This Neovim configuration includes the following plugins and features:

1. File Explorer: nvim-tree
2. Git Integration: gitsigns
3. Indentation Guides: indent-blankline
4. Autopairs: nvim-autopairs
5. Completion: nvim-cmp
6. Debugging: nvim-dap
7. LSP Configuration: nvim-lspconfig
8. Fuzzy Finder: telescope
9. TODO Comments: todo-comments
10. Color Scheme: tokyonight
11. Syntax Highlighting: treesitter
12. Keybinding Helper: which-key
13. Code Formatting: conform
14. Miniature Plugins: mini

## Installation

1. Backup your existing Neovim configuration if you have one.
2. Clone this repository into your Neovim configuration directory:
   ```
   git clone https://github.com/yourusername/neovim-config.git ~/.config/nvim
   ```
3. Ensure you have Neovim 0.5+ installed.
4. Launch Neovim. The plugin manager should automatically install the required plugins.

## Customization

To customize this configuration:

1. Modify `init.lua` for global settings.
2. Add or modify plugin configurations in `lua/prinsmike/plugins/`.
3. Adjust specific plugin settings in `lua/prinsmike/configs/`.

