# Contributing

Thanks for your interest! This is a personal Neovim configuration, but issues and
pull requests are welcome.

The working guidelines — repository layout, workflow, and conventions — live in
**[AGENTS.md](AGENTS.md)**. Please read it before opening a PR. In short:

- Create a branch for your change; don't commit directly to `main`.
- Keep commits small and atomic, using [Conventional Commits](https://www.conventionalcommits.org/)
  (`feat:`, `fix:`, `docs:`, `chore:`, `refactor:`).
- Format Lua with `stylua --indent-type Tabs --indent-width 2` (CI runs
  `stylua --check` and `luacheck`).
- Add a note under `## [Unreleased]` in [CHANGELOG.md](CHANGELOG.md) for anything
  notable.
- Open a PR against `main`; CI must pass before it can merge.

For the full details — adding plugins, LSP servers, and formatters — see
[AGENTS.md](AGENTS.md).
