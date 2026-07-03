# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed

- Fixed a which-key conflict where `<leader>ac` was registered both as a group ("[C]laude") and as the direct Claude Code toggle mapping; removed the redundant group so the toggle works (the other Claude commands already live directly under the `[A]I` group)
- Fixed a typo (`vim.fn.lin`) in the gitsigns visual-mode reset-hunk mapping (`<leader>vhr`) that caused an error when resetting a selected hunk
- Fixed Telescope previewer crash (`attempt to call field 'ft_to_lang'`) caused by the nvim-treesitter `main` branch removing the legacy parsers/configs API; Telescope now highlights previews via Neovim's native `vim.treesitter.start`

### Changed

- Enabled `ignorecase` so that `smartcase` takes effect: searches are now case-insensitive unless the query contains an uppercase letter (previously `smartcase` was a no-op because `ignorecase` was off)
- Migrated nvim-treesitter from the `master` branch to the `main` branch for Neovim 0.12 compatibility
  - The `master` branch does not support Neovim 0.12 and crashed the treesitter highlighter
  - Highlighting and indentation are now enabled per-buffer via a `FileType` autocmd
  - Parsers are now installed via `require("nvim-treesitter").install(...)`
  - Requires the `tree-sitter-cli` (install via your package manager, not npm)

### Added

- Added custom minimal colorscheme based on principles from https://tonsky.me/blog/syntax-highlighting/
  - Uses only 5 strategic colors (green for strings/numbers, purple for constants, yellow for comments, blue for top-level definitions, gray for punctuation)
  - Avoids over-highlighting by not coloring keywords, variables, or function calls
  - Makes comments prominent with bold yellow instead of graying them out

### Removed

- Removed Tokyo Night colorscheme in favor of custom minimal theme

## [0.3.0] - 2025-11-08

### Added

- Added Claude Code slash commands for easier configuration management:
  - `/add-plugin` - Add new plugins with proper lazy.nvim setup
  - `/add-lsp` - Add new LSP servers
  - `/add-formatter` - Add new formatters to conform.nvim
  - `/list-keys` - List all custom keybindings
  - `/changelog` - Add changelog entries
  - `/release` - Create versioned releases
  - `/health-check` - Verify configuration health
  - `/find-config` - Locate specific settings
- Added `.claude/` directory with command definitions and documentation
- Added suggested hooks configuration for Claude Code integration

## [0.2.0] - 2025-11-08

### Added

- Added claudecode.nvim plugin for Neovim integration with Claude Code
- Added snacks.nvim dependency for terminal support

## [0.1.0] - 2025-11-08

Initial release of personal Neovim configuration.

### Added

- Added CLAUDE.md for Claude Code project-specific instructions
- Added spell check configuration (British English for markdown files)
- Added live grep through hidden files in Telescope
- Added .gitignore file
- Initial Neovim configuration with lazy.nvim
- LSP configuration with Mason for server management
- Formatting with conform.nvim (format-on-save enabled)
- Telescope fuzzy finder with extensive keybindings
- Treesitter syntax highlighting
- Git integration with gitsigns
- Completion engine with nvim-cmp
- File explorer with nvim-tree
- Keybinding helper with which-key

### Changed

- Improved keybindings for changing window size
- Reconfigured which-key for v3 compatibility
- Refactored gitsigns configuration
- Improved README introduction and documentation
- Stopped tracking lazy-lock.json
- Various small fixes and improvements

### Removed

- Removed outdated AI plugins (claude.vim and avante)

### Fixed

- Project tree structure improvements

[Unreleased]: https://github.com/prinsmike/nvim/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/prinsmike/nvim/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/prinsmike/nvim/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/prinsmike/nvim/releases/tag/v0.1.0
