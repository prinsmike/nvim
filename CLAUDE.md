# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration built with lazy.nvim as the plugin manager. The configuration uses a modular Lua-based architecture with plugins organized in separate files under `lua/prinsmike/plugins/`.

## Key Architecture

### Plugin Loading System

- **Plugin Manager**: lazy.nvim (auto-installed if not present)
- **Plugin Location**: All plugins are defined in `lua/prinsmike/plugins/*.lua` as separate modules
- **Loading**: Each plugin file returns a lazy.nvim spec table that gets required in `init.lua:96-112`
- **Lock File**: `lazy-lock.json` pins exact plugin versions (not tracked in git)

### Configuration Structure

```
init.lua                      # Main entry point: vim options, keymaps, autocommands, lazy.nvim setup
CHANGELOG.md                  # Project changelog (Keep a Changelog format)
README.md                     # Project documentation
lua/prinsmike/
  plugins/                    # Plugin definitions (each file returns a lazy.nvim spec)
    nvim-lspconfig.lua       # LSP setup with Mason for server management
    conform.lua              # Formatting with format-on-save
    telescope.lua            # Fuzzy finder with extensive keybindings
    treesitter.lua           # Syntax highlighting
    gitsigns.lua             # Git integration
    nvim-cmp.lua             # Completion engine
    nvim-tree.lua            # File explorer
    which-key.lua            # Keybinding helper
    tokyonight.lua           # Tokyo Night colorscheme
    todo-comments.lua        # Highlight and search TODO/FIXME comments
    mini.lua                 # Collection of minimal plugins (mini.nvim)
    nvim-autopairs.lua       # Auto-close brackets, quotes, etc.
    indent-blankline.lua     # Indentation guides
  configs/
    nvim-tree.lua            # Specific configuration for nvim-tree
```

**Note**: Some simple plugins are defined inline in `init.lua` (lines 97-98):
- `vim-sleuth` - Automatic indent detection
- `Comment.nvim` - Commenting functionality

### LSP Configuration

The LSP setup (nvim-lspconfig.lua:77-92) defines enabled language servers:
- gopls (Go)
- pyright (Python)
- rust_analyzer (Rust)
- lua_ls (Lua)

Mason automatically installs these servers plus additional tools like stylua. To add a new language server, add it to the `servers` table and it will be auto-installed and configured.

### Formatting

Conform.nvim handles formatting with:
- Format-on-save enabled by default (500ms timeout)
- Manual format via `<leader>f`
- LSP fallback except for C/C++
- Currently only stylua configured for Lua files

Add new formatters to `formatters_by_ft` in conform.lua:23-25.

## Common Commands

### Plugin Management

```bash
# Update plugins (run inside Neovim)
:Lazy update

# Check plugin status
:Lazy

# Clean unused plugins
:Lazy clean

# Restore from lockfile
:Lazy restore
```

### LSP and Mason

```bash
# Open Mason installer UI (run inside Neovim)
:Mason

# Update all Mason packages
:MasonUpdate

# Install a specific tool
:MasonInstall <tool-name>
```

### Treesitter

```bash
# Update parsers (run inside Neovim)
:TSUpdate

# Check installed parsers
:TSInstallInfo
```

## Important Keybindings

**Leader key**: Space

### File Navigation
- `<leader>sf` - Search files (Telescope)
- `<leader>sg` - Live grep with hidden files
- `<leader>sn` - Search Neovim config files
- `<leader><leader>` - Find open buffers

### LSP
- `gd` - Go to definition
- `gr` - Go to references
- `gI` - Go to implementation
- `K` - Hover documentation
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code action
- `<leader>f` - Format buffer

### Terminal
- `<leader>ts` - Open terminal in horizontal split
- `<leader>tv` - Open terminal in vertical split
- `<leader>tt` - Open terminal in new tab

## Development Notes

### Code Style

- Uses tabs (not spaces) with tabstop=2, shiftwidth=2
- Spell check is auto-enabled for markdown files (British English)
- expandtab is set to false (uses tabs)

### Adding New Plugins

1. Create a new file in `lua/prinsmike/plugins/<plugin-name>.lua`
2. Return a lazy.nvim spec table with plugin configuration
3. Add `require("prinsmike.plugins.<plugin-name>")` to the setup table in `init.lua:96-112`
4. Restart Neovim or run `:Lazy reload`
5. Add entry to CHANGELOG.md under `[Unreleased]` section

### Changelog Management

This project follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and [Semantic Versioning](https://semver.org/spec/v2.0.0.html):

- All notable changes should be added to the `[Unreleased]` section in CHANGELOG.md
- Use categories: Added, Changed, Deprecated, Removed, Fixed, Security
- When ready to release a new version, move unreleased changes to a new version section with the release date
- Create an annotated git tag for the release: `git tag -a vX.Y.Z -m "Release vX.Y.Z"`

### LSP Keybindings

All LSP keybindings are automatically set up via the LspAttach autocmd in nvim-lspconfig.lua:11-66. They are buffer-local and only activate when an LSP client attaches to a buffer.
