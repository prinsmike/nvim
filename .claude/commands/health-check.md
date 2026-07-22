---
description: Check the health of the Neovim configuration
---

You are helping check the health of this Neovim configuration.

Perform the following checks:

1. Verify all plugin files in `lua/prinsmike/plugins/` are properly required in `init.lua`
2. Check that CHANGELOG.md follows Keep a Changelog format
3. Verify all plugin files return valid lazy.nvim spec tables
4. Look for common issues:
   - Missing dependencies
   - Duplicate keybindings
   - Syntax errors in Lua files
5. Check that README.md is up to date with the actual plugins installed
6. Verify git ignore patterns are appropriate

Provide a summary report with:
- ✓ Items that are correct
- ⚠ Warnings for potential issues
- ✗ Critical problems that need fixing
