# prinsmike's Neovim Configuration

[![CI](https://github.com/prinsmike/nvim/actions/workflows/ci.yml/badge.svg)](https://github.com/prinsmike/nvim/actions/workflows/ci.yml)
[![Latest release](https://img.shields.io/github/v/release/prinsmike/nvim?sort=semver)](https://github.com/prinsmike/nvim/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A modular Neovim configuration built with [lazy.nvim](https://github.com/folke/lazy.nvim), featuring LSP support, code formatting, fuzzy finding, and git integration.

![Neovim running this configuration: the nvim-tree file explorer on the left, `init.lua` open in the centre with the custom minimal colour scheme, and the Claude Code terminal docked on the right.](images/screenshot.png)

## Features

- **Plugin Manager**: lazy.nvim with lockfile for reproducible installs
- **LSP Support**: Automatic language server installation via Mason
  - Go (gopls)
  - Python (pyright)
  - Rust (rust_analyzer)
  - Lua (lua_ls)
- **Code Formatting**: Format-on-save with conform.nvim
- **Debugging**: nvim-dap with nvim-dap-ui and Go (delve) support via nvim-dap-go
- **Testing**: neotest test runner with the neotest-golang adapter (run and debug tests in-editor)
- **Fuzzy Finding**: Telescope for files, grep, buffers, and config navigation
- **Syntax Highlighting**: Treesitter with auto-installed parsers
- **Git Integration**: Gitsigns for inline git status and blame
- **Completion**: nvim-cmp with LSP, buffer, and path sources
- **File Explorer**: nvim-tree
- **UI Enhancements**: which-key, indent-blankline, mini.nvim suite
- **AI Integration**: Claude Code (claudecode.nvim), optionally sandboxed in a per-project container
- **Color Scheme**: Custom minimal theme (inspired by [tonsky.me/blog/syntax-highlighting](https://tonsky.me/blog/syntax-highlighting/))

## Prerequisites

- Neovim 0.11+ (0.12 recommended; uses native `vim.lsp.config`/`vim.lsp.enable`, `vim.diagnostic.jump`, and the nvim-treesitter `main` branch)
- Git
- A Nerd Font (for icons)
- ripgrep (for Telescope live grep)
- tree-sitter CLI (for installing Treesitter parsers — install via your package manager, not npm)
- A C compiler (for Treesitter parsers)
- (For Go development) the Go toolchain — used by gopls, `go test` via neotest, and delve debugging; delve is auto-installed by Mason, but its `dlv` binary requires Go on your `PATH`

## Installation

1. **Backup** your existing Neovim configuration:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   mv ~/.local/share/nvim ~/.local/share/nvim.backup
   ```

2. **Clone** this repository:
   ```bash
   git clone https://github.com/prinsmike/nvim.git ~/.config/nvim
   ```

3. **Launch** Neovim:
   ```bash
   nvim
   ```

   Lazy.nvim will automatically install all plugins. Mason will then install the configured LSP servers and tools.

4. **Restart** Neovim once installation completes.

## Configuration Structure

```
init.lua                      # Main entry point: options, keymaps, autocommands
lazy-lock.json               # Plugin version lockfile
lua/prinsmike/
  plugins/                   # Plugin definitions (each file returns a lazy.nvim spec)
    nvim-lspconfig.lua      # LSP configuration with Mason integration
    conform.lua             # Code formatting setup
    nvim-dap.lua            # Debugger (nvim-dap + dap-ui + dap-go/delve)
    neotest.lua             # Test runner (neotest + neotest-golang)
    telescope.lua           # Fuzzy finder configuration
    treesitter.lua          # Syntax highlighting
    gitsigns.lua            # Git integration
    nvim-cmp.lua            # Completion engine
    nvim-tree.lua           # File explorer
    which-key.lua           # Keybinding helper
    [others]                # Additional plugins
  configs/
    nvim-tree.lua           # Extended nvim-tree configuration
scripts/
  claude-container          # Runs Claude Code in a container, or falls back to the host
containers/                 # Example images (base, go, node, python, terraform)
docs/                       # Design documents
```

## Updating

### Update All Plugins

```vim
:Lazy update
```

This updates all plugins to their latest versions and updates the lockfile.

### Update Mason Tools

```vim
:MasonUpdate
```

Updates all installed LSP servers, formatters, and linters.

### Update Treesitter Parsers

```vim
:TSUpdate
```

Updates all installed Treesitter parsers to the latest versions.

### Restore from Lockfile

To restore exact plugin versions from `lazy-lock.json`:

```vim
:Lazy restore
```

## Plugin Management

### View Plugin Status

```vim
:Lazy
```

Opens the Lazy.nvim UI showing installed plugins, their status, and available updates.

### Clean Unused Plugins

```vim
:Lazy clean
```

Removes plugins that are no longer specified in the configuration.

### Install Specific Tools

```vim
:Mason
```

Opens the Mason UI where you can interactively install LSP servers, formatters, and linters.

To install a specific tool:

```vim
:MasonInstall stylua
```

## Key Bindings

**Leader key**: `Space`

### File Navigation

| Key | Action |
|-----|--------|
| `<leader>sf` | Search files (Telescope) |
| `<leader>sg` | Live grep (search content in files) |
| `<leader>sn` | Search Neovim config files |
| `<leader><leader>` | Find open buffers |
| `<leader>sh` | Search help tags |
| `<leader>sk` | Search keymaps |

### LSP

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `gI` | Go to implementation |
| `gD` | Go to declaration |
| `K` | Hover documentation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>f` | Format buffer |

### Debug (nvim-dap)

| Key | Action |
|-----|--------|
| `<F5>` | Start / continue |
| `<F1>` | Step into |
| `<F2>` | Step over |
| `<F3>` | Step out |
| `<F7>` | Toggle debug UI |
| `<leader>b` | Toggle breakpoint |
| `<leader>B` | Set conditional breakpoint |

### Test (neotest)

| Key | Action |
|-----|--------|
| `<leader>Tr` | Run nearest test |
| `<leader>Tf` | Run tests in file |
| `<leader>Ta` | Run all tests (project) |
| `<leader>Td` | Debug nearest test (dap) |
| `<leader>TS` | Stop running test |
| `<leader>Ts` | Toggle summary |
| `<leader>To` | Show test output |
| `<leader>TO` | Toggle output panel |
| `<leader>Tw` | Watch file |

### Terminal

| Key | Action |
|-----|--------|
| `<leader>ts` | Open terminal in horizontal split |
| `<leader>tv` | Open terminal in vertical split |
| `<leader>tt` | Open terminal in new tab |

### File Explorer

| Key | Action |
|-----|--------|
| `<leader>wft` | Toggle nvim-tree |
| `<leader>wff` | Focus nvim-tree |

### UI Toggles

| Key | Action |
|-----|--------|
| `<leader>uw` | Toggle line wrap |
| `<leader>us` | Toggle spell check |
| `<leader>uh` | Toggle LSP inlay hints |

### AI (Claude Code)

| Key | Action |
|-----|--------|
| `<leader>ac` | Toggle Claude Code |
| `<leader>af` | Focus Claude Code |
| `<leader>as` | Send selection to Claude Code (visual mode) |
| `<leader>am` | Select Claude model |
| `<leader>aa` / `<leader>ad` | Accept / deny Claude diff |

For more keybindings, press `<leader>` in normal mode to see which-key suggestions.

#### Running Claude Code in a container

Claude Code is launched through [`scripts/claude-container`](scripts/claude-container),
which by default just execs your host installation — nothing changes unless you
ask it to.

To confine the agent to a single repository, drop a `.claude-container` file at
that repository's root (see [`.claude-container.example`](.claude-container.example)):

```ini
variant=go
```

The next session builds [`containers/go.Dockerfile`](containers/) and runs
`claude` inside it, with only that repository, your Claude configuration
directory and your `.gitconfig` mounted. Your editor, LSP servers and formatters
stay on the host, and diffs, selections and `@`-mentions keep working because
the repository is mounted at the same absolute path it has on the host.

Without a file, `CLAUDE_CONTAINER=go nvim` does the same thing for one session,
and `CLAUDE_CONTAINER=off` forces the host installation.

To let the agent push and open pull requests, add:

```ini
ssh=agent
github=token
```

`ssh=agent` forwards your SSH agent socket, so git can push without the private
key ever entering the container. `github=token` passes a `gh` token in, which is
needed because `gh` keeps its token in the system keyring rather than in a file.
Claude Code's own credentials need nothing: its OAuth tokens live in the
configuration directory that is already mounted, so a Max subscription
authenticates with no API key and no API costs.

Separate accounts get separate configuration directories, and each container
sees only its own:

```bash
# personal
nvim

# work — Claude account, GitHub account and SSH keys all switch together
CLAUDE_CONFIG_DIR=~/.claude-work \
  GH_CONFIG_DIR=~/.config/gh-work \
  SSH_AUTH_SOCK=~/.ssh/agent-work.sock \
  nvim
```

Requires Docker. The design, the security trade-offs and the limitations are in
[docs/claude-container.md](docs/claude-container.md).

## Customization

### Adding a New Plugin

1. Create a new file in `lua/prinsmike/plugins/<plugin-name>.lua`
2. Return a lazy.nvim spec table:
   ```lua
   return {
     "author/plugin-name",
     config = function()
       -- Plugin configuration
     end,
   }
   ```
3. Add the require statement to the `require("lazy").setup({ ... })` table in `init.lua`
4. Restart Neovim or run `:Lazy reload`

### Adding a New LSP Server

1. Open `lua/prinsmike/plugins/nvim-lspconfig.lua`
2. Add the server name to the `servers` list
3. (Optional) Add server-specific overrides with `vim.lsp.config("<server>", { ... })`
4. Restart Neovim - Mason installs the server and `mason-lspconfig` enables it automatically

### Adding a New Formatter

1. Open `lua/prinsmike/plugins/conform.lua`
2. Add the formatter to `formatters_by_ft`
3. Install the formatter via Mason: `:MasonInstall <formatter-name>`

### Modifying Settings

- **Global Neovim settings**: Edit the options and keymaps near the top of `init.lua`
- **Plugin-specific settings**: Edit the corresponding file in `lua/prinsmike/plugins/`
- **Extended plugin configs**: Add/modify files in `lua/prinsmike/configs/`

## Code Style

This configuration uses:
- **Indentation**: Tabs (not spaces)
- **Tab width**: 2 spaces
- **Spell check**: Enabled for markdown files (British English)

## Troubleshooting

### LSP Not Working

1. Check if the server is installed: `:Mason`
2. Check LSP status: `:LspInfo`
3. Restart the LSP: `:LspRestart`

### Treesitter Errors

1. Update parsers: `:TSUpdate`
2. Reinstall specific parser: `:TSInstall <language>`
3. Check parser/config status: `:checkhealth nvim-treesitter`

### Plugin Issues

1. Update plugins: `:Lazy update`
2. Clean and reinstall: `:Lazy clean` then restart Neovim
3. Check for errors: `:Lazy log`

## License

[MIT](LICENSE). This is a personal configuration — feel free to use and adapt it.
