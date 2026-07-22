# AGENTS.md

Guidance for AI agents (and humans) working in this repository.

## What this is

A personal, modular Neovim configuration built on [lazy.nvim](https://github.com/folke/lazy.nvim).
It is meant to be cloned into `~/.config/nvim`. There is no build or test suite —
"running" it means loading it in Neovim.

## Layout

- `init.lua` — entry point: options, keymaps, autocommands, `lazy.setup(...)`.
- `lua/prinsmike/plugins/*.lua` — one file per plugin, each returning a lazy.nvim spec.
- `lua/prinsmike/configs/*.lua` — extended configuration pulled out of plugin specs.
- `lazy-lock.json` — plugin lockfile; **tracked** and committed with plugin changes.
- `spell/` — spell files. `.claude/commands/` — repo slash commands.

## Workflow

- Create a new branch for new work — never commit directly to `main`.
- Commit frequently and atomically: one logical change per commit.
- Open a PR to merge into `main` and wait for a human review before merging.
- Make sure `CHANGELOG.md` is up to date before cutting a release.

## Conventions

- **Code style**: tabs, not spaces; tab width 2. Format Lua with
  `stylua --indent-type Tabs --indent-width 2`.
- **Commits**: Conventional Commits (`feat:`, `fix:`, `docs:`, `chore:`,
  `refactor:`), with an optional scope, e.g. `feat(go): add neotest runner`.
- **Changelog**: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) format;
  add notable changes under `## [Unreleased]` as you go.
- **Versioning**: [Semantic Versioning](https://semver.org/); tags are `vMAJOR.MINOR.PATCH`.
- **Prose**: British English (matches the markdown spell-check setting).

## Adding things

- **Plugin**: add `lua/prinsmike/plugins/<name>.lua` returning a spec, then
  `require` it from the `lazy.setup` table in `init.lua`.
- **LSP server**: add it to the `servers` list in
  `lua/prinsmike/plugins/nvim-lspconfig.lua`; Mason installs it automatically.
- **Formatter**: add it to `formatters_by_ft` in `lua/prinsmike/plugins/conform.lua`.

Repo slash commands automate these — see `.claude/commands/`.
