# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- [markdown-preview.nvim](https://github.com/selimacerbas/markdown-preview.nvim): live Markdown preview in the browser with Mermaid diagrams, KaTeX maths and scroll sync, served by a pure Lua HTTP server so no Node.js is needed. Loads on Markdown and Mermaid files; `<leader>mp` / `<leader>mr` / `<leader>ms` start, refresh and stop the preview

## [0.7.0] - 2026-08-05

Optional containerised Claude Code: the agent can now be confined to a single
repository, with the host installation still the default.

### Added

- Optional containerised Claude Code. `scripts/claude-container` runs the agent in a container scoped to a single repository, mounting only that repository, the Claude configuration directory and `.gitconfig`. The repository is mounted at the same absolute path it has on the host, which is what keeps diffs, selections and `@`-mentions working — every path in the claudecode.nvim protocol is absolute
- Opt-in per project via a `.claude-container` file at the repository root, or per session via `CLAUDE_CONTAINER`; with neither, the launcher execs the host installation unchanged, so the default behaviour is untouched
- Example images in `containers/` for `base`, `go`, `node`, `python` and `terraform`, built on demand and tagged with a hash of the Dockerfile, the shared setup script and the host UID/GID, so editing one rebuilds automatically. The `terraform` variant carries the Terraform CLI, tflint, terraform-docs and trivy, and no cloud credentials: the container isolates the filesystem, not the infrastructure, so anything reachable by `terraform apply` has to be mounted in deliberately
- `network=bridge` as an alternative to the default shared network namespace: the agent runs in its own namespace with only the editor's WebSocket port forwarded in, and cannot reach host loopback services
- `ssh=agent`, forwarding the SSH agent socket so the agent can `git push` without the private key ever entering the container, and `github=token`, passing a `gh` token in so pull requests can be opened and reviewed. Both default to off. Claude Code itself needs no extra configuration: its OAuth tokens live in the configuration directory that is already mounted, so a Max subscription authenticates with no API key and no API costs
- `docs/claude-container.md`, recording the design, authentication, the security trade-offs, the alternatives considered and the known limitations

### Changed

- `claudecode.nvim` now launches through `terminal_cmd`, pointing at the in-repo launcher

## [0.6.0] - 2026-07-22

Public-release preparation: licensing, CI, and contributor/agent docs, plus a
startup-crash fix.

### Added

- `AGENTS.md`, a concise agent/contributor guide (project layout, workflow, and conventions), imported by a thin `CLAUDE.md` via `@AGENTS.md`
- `CONTRIBUTING.md`, a short contributor guide that points to `AGENTS.md` for the full workflow and conventions
- MIT `LICENSE`
- Continuous integration: a `ci.yml` workflow running `stylua --check` (with a `stylua.toml` pinning the project's tabs / width-2 style) and `luacheck` on every push and pull request
- A tag-triggered `release.yml` workflow that fails a `v*` tag without a matching `CHANGELOG.md` entry and publishes that entry as the GitHub release notes
- Dependabot configuration for weekly, grouped GitHub Actions updates
- A pull request template and a `CODEOWNERS` file
- A `.gitignore` for local Neovim and editor state
- README status badges (CI, latest release, licence) and a screenshot of the configuration in action

### Changed

- Bumped GitHub Actions: `actions/checkout` v4 → v7 and `JohnnyMorganz/stylua-action` v4 → v5
- Updated the plugin lockfile (`lazy-lock.json`) to current plugin versions

### Fixed

- Removed `rustfmt` from the `mason-tool-installer` install list; Mason dropped the `rustfmt` package (it is a `rustup` component, not a Mason binary), so requesting it crashed startup with `Cannot find package "rustfmt"`. Rust formatting still works via conform using the `rustup`-provided `rustfmt` on `PATH`

## [0.5.0] - 2026-07-03

### Added

- Installed Treesitter parsers for Go (`go`, `gomod`, `gosum`, `gotmpl`, `gowork`), giving Go, go.mod, go.sum, template, and go.work files proper syntax highlighting and indentation
- Configured gopls with Go-specific settings: `gofumpt` formatting, `staticcheck`, placeholder completions, extra analyses (`unusedparams`, `shadow`, `nilness`, `unusedwrite`, `useany`), inlay hints, and code lenses (test, tidy, generate, upgrade/vendor dependency)
- Enabled LSP inlay hints on attach for any server that supports them (e.g. gopls parameter names and inferred types), with a `<leader>uh` toggle
- Added a debugger via `nvim-dap` with `nvim-dap-ui` and `nvim-dap-go` (delve, auto-installed through `mason-nvim-dap`). Keybindings: `<F5>` continue, `<F1>`/`<F2>`/`<F3>` step into/over/out, `<F7>` toggle the debug UI, `<leader>b` toggle breakpoint, `<leader>B` conditional breakpoint. The DAP UI opens and closes automatically with the debug session
- Added a test runner via `neotest` with the `neotest-golang` adapter (uses the `go test` runner and drives `nvim-dap-go` for debugging). Keybindings under the new `[T]est` group (`<leader>T`): `Tr` run nearest, `Tf` run file, `Ta` run project, `Td` debug nearest, `TS` stop, `Ts` toggle summary, `To`/`TO` show output/toggle output panel, `Tw` watch file

### Changed

- Updated README to document the new debugger and test runner: added Debugging and Testing feature bullets, the Go toolchain prerequisite, the `nvim-dap.lua`/`neotest.lua` files in the config structure, and Debug/Test keybinding tables plus the `<leader>uh` inlay-hint toggle

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

[Unreleased]: https://github.com/prinsmike/nvim/compare/v0.7.0...HEAD
[0.7.0]: https://github.com/prinsmike/nvim/compare/v0.6.0...v0.7.0
[0.6.0]: https://github.com/prinsmike/nvim/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/prinsmike/nvim/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/prinsmike/nvim/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/prinsmike/nvim/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/prinsmike/nvim/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/prinsmike/nvim/releases/tag/v0.1.0
