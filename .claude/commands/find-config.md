---
description: Find where a specific feature or setting is configured
---

You are helping the user find where a specific feature or setting is configured in this Neovim setup.

Ask the user what they're looking for (examples: colorscheme, LSP server, formatter, keybinding, plugin, etc.)

Then search through:
1. `init.lua` - Main configuration, vim options, general keybindings
2. `lua/prinsmike/plugins/*.lua` - Individual plugin configurations
3. `lua/prinsmike/configs/*.lua` - Extended plugin configurations

Provide:
1. Exact file path and line numbers where it's configured
2. The relevant code snippet
3. Brief explanation of what it does
4. Related configuration if applicable

If it's a plugin setting, also mention:
- The plugin's GitHub repo
- Link to relevant documentation
