# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Installed Treesitter parsers for Go (`go`, `gomod`, `gosum`, `gotmpl`, `gowork`), giving Go, go.mod, go.sum, template, and go.work files proper syntax highlighting and indentation
- Configured gopls with Go-specific settings: `gofumpt` formatting, `staticcheck`, placeholder completions, extra analyses (`unusedparams`, `shadow`, `nilness`, `unusedwrite`, `useany`), inlay hints, and code lenses (test, tidy, generate, upgrade/vendor dependency)
- Enabled LSP inlay hints on attach for any server that supports them (e.g. gopls parameter names and inferred types), with a `<leader>uh` toggle

## [0.4.0] - 2026-07-03

### Fixed

- Fixed LSP server configuration that was silently dropped on mason-lspconfig v2: the removed `handlers` API meant the `lua_ls` settings and nvim-cmp capabilities were never applied. Migrated to the native `vim.lsp.config` / `vim.lsp.enable` (`automatic_enable`) approach, restoring them
- Fixed a which-key conflict where `<leader>ac` was registered both as a group ("[C]laude") and as the direct Claude Code toggle mapping; removed the redundant group so the toggle works (the other Claude commands already live directly under the `[A]I` group)
- Fixed a typo (`vim.fn.lin`) in the gitsigns visual-mode reset-hunk mapping (`<leader>vhr`) that caused an error when resetting a selected hunk
- Fixed Telescope previewer crash (`attempt to call field 'ft_to_lang'`) caused by the nvim-treesitter `main` branch removing the legacy parsers/configs API; Telescope now highlights previews via Neovim's native `vim.treesitter.start`

### Changed

- Enabled `ignorecase` so that `smartcase` takes effect: searches are now case-insensitive unless the query contains an uppercase letter (previously `smartcase` was a no-op because `ignorecase` was off)
- Replaced deprecated Neovim APIs in `init.lua` for 0.12 compatibility: `vim.highlight.on_yank` → `vim.hl.on_yank`, `vim.loop` → `vim.uv`, and `vim.diagnostic.goto_prev`/`goto_next` → `vim.diagnostic.jump` (diagnostic navigation behavior unchanged)
- Replaced conform.nvim's deprecated `lsp_fallback` option with `lsp_format` (formatting behavior unchanged)
- Moved the spell-check toggle from `<leader>ps` to `<leader>us` under the new `[U]I toggle` group
- Cleaned up which-key groups to match reality: relabeled `<leader>d` from "[D]ebugging" (no debugger configured) to "[D]ocument", and removed the empty "[P]aperwork" group
- Hardened the Telescope treesitter-previewer patch: it now wraps telescope's own highlighter and only falls back to the native starter on error, so a future upstream fix is used instead of being clobbered
- Updated README to match the current config: minimal colorscheme (was Tokyo Night), Neovim 0.11+/tree-sitter CLI prerequisites, new `<leader>u` UI toggles and Claude Code keybindings, the native `vim.lsp.config` server-add instructions, and `:checkhealth nvim-treesitter` (dropped the removed `:TSInstallInfo`)
- Migrated nvim-treesitter from the `master` branch to the `main` branch for Neovim 0.12 compatibility
  - The `master` branch does not support Neovim 0.12 and crashed the treesitter highlighter
  - Highlighting and indentation are now enabled per-buffer via a `FileType` autocmd
  - Parsers are now installed via `require("nvim-treesitter").install(...)`
  - Requires the `tree-sitter-cli` (install via your package manager, not npm)

### Added

- Added a `[U]I toggle` which-key group (`<leader>u`) with a new line-wrap toggle (`<leader>uw`)
- Started tracking `lazy-lock.json` for reproducible plugin versions across machines (removed the `.gitignore` entry that previously excluded it)
- Added custom minimal colorscheme based on principles from https://tonsky.me/blog/syntax-highlighting/
  - Uses only 5 strategic colors (green for strings/numbers, purple for constants, yellow for comments, blue for top-level definitions, gray for punctuation)
  - Avoids over-highlighting by not coloring keywords, variables, or function calls
  - Makes comments prominent with bold yellow instead of graying them out

### Removed

- Removed the `<leader>vhu` "git undo stage hunk" mapping; `gitsigns.undo_stage_hunk` no longer exists on the gitsigns `main` branch (staging is now a toggle via `stage_hunk`, so re-running `<leader>vhs` on a staged hunk unstages it)
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

[Unreleased]: https://github.com/prinsmike/nvim/compare/v0.4.0...HEAD
[0.4.0]: https://github.com/prinsmike/nvim/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/prinsmike/nvim/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/prinsmike/nvim/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/prinsmike/nvim/releases/tag/v0.1.0
