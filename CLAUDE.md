A personal Neovim configuration built with lazy.nvim as plugin manager. Uses a modular Lua-based architecture with plugins organized in separate files under `lua/prinsmike/plugins/`.

**Note**: Some simple plugins are defined inline in `init.lua`

The LSP setup (nvim-lspconfig.lua) defines enabled language servers; automatically installed by Mason:
- gopls (Go)
- pyright (Python)
- rust_analyzer (Rust)
- lua_ls (Lua)

Conform.nvim handles formatting.

Add new formatters to `formatters_by_ft` in conform.lua.

### Adding New Plugins

1. Create a new file in `lua/prinsmike/plugins/<plugin-name>.lua`
2. Return a lazy.nvim spec table with plugin configuration
3. Add `require("prinsmike.plugins.<plugin-name>")` to the setup table in `init.lua`

### Changelog Management

This project follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and [Semantic Versioning](https://semver.org/spec/v2.0.0.html):

- All notable changes should be added to the `[Unreleased]` section in CHANGELOG.md
- Use categories: Added, Changed, Deprecated, Removed, Fixed, Security
- When ready to release a new version, move unreleased changes to a new version section with the release date
- Create an annotated git tag for the release: `git tag -a vX.Y.Z -m "Release vX.Y.Z"`

### LSP Keybindings

All LSP keybindings are automatically set up via the LspAttach autocmd in nvim-lspconfig.lua. They are buffer-local and only activate when an LSP client attaches to a buffer.
