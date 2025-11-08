# Claude Code Configuration

This directory contains custom slash commands and configuration for working with this Neovim configuration using Claude Code.

## Available Slash Commands

| Command | Description |
|---------|-------------|
| `/add-plugin` | Add a new plugin to the configuration with proper lazy.nvim setup |
| `/add-lsp` | Add a new LSP server to nvim-lspconfig |
| `/add-formatter` | Add a new formatter to conform.nvim |
| `/list-keys` | List all custom keybindings across the configuration |
| `/changelog` | Add an entry to CHANGELOG.md following Keep a Changelog format |
| `/release` | Create a new versioned release with git tags |
| `/health-check` | Verify the configuration is properly structured and consistent |
| `/find-config` | Find where a specific feature or setting is configured |

## Usage Examples

```bash
# Add a new plugin
/add-plugin
# Claude will ask which plugin and help you configure it

# Add TypeScript LSP support
/add-lsp
# Claude will guide you through adding tsserver

# See all keybindings
/list-keys

# Add a changelog entry
/changelog

# Create a new release
/release
```

## Suggested Hooks

While hooks are configured in Claude Code settings (not in this directory), here are recommended hooks for this project:

### Format on Write (Optional)

If you want Claude to auto-format Lua files when editing:

```json
{
  "hooks": {
    "afterWrite": {
      "command": "stylua --indent-type Tabs --indent-width 2 ${filePath}",
      "pattern": "*.lua"
    }
  }
}
```

### Validate Changelog (Optional)

Ensure changelog follows proper format:

```json
{
  "hooks": {
    "afterWrite": {
      "command": "grep -q '\\[Unreleased\\]' CHANGELOG.md || echo 'Warning: CHANGELOG.md missing [Unreleased] section'",
      "pattern": "CHANGELOG.md"
    }
  }
}
```

## Project Structure

This Neovim configuration follows these conventions:
- **Plugin files**: `lua/prinsmike/plugins/*.lua` (each returns a lazy.nvim spec)
- **Extended configs**: `lua/prinsmike/configs/*.lua`
- **Main entry**: `init.lua`
- **Changelog**: `CHANGELOG.md` (Keep a Changelog format)
- **Formatting**: Tabs (not spaces), tabstop=2

## Tips

1. Always use the `/changelog` command when making notable changes
2. Use `/health-check` periodically to catch configuration issues
3. Use `/list-keys` to avoid creating duplicate keybindings
4. Use `/release` when ready to tag a new version
