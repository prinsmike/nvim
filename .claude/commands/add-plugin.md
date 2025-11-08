---
description: Add a new plugin to the Neovim configuration
---

You are helping add a new plugin to this Neovim configuration.

Follow these steps:

1. Ask the user which plugin they want to add (GitHub repo URL or plugin name)
2. Ask for any configuration options they want to set
3. Create a new file `lua/prinsmike/plugins/<plugin-name>.lua` with:
   - Proper lazy.nvim spec format
   - Any dependencies specified
   - Configuration in the `config` function
   - Appropriate keybindings if needed
4. Add the require statement to `init.lua` in the lazy.nvim setup (around line 96-112)
5. Add an entry to CHANGELOG.md under `[Unreleased]` > `### Added`
6. Show the user what was created and suggest they run `:Lazy sync` in Neovim

Use tabs (not spaces) with tabstop=2 for all Lua files.