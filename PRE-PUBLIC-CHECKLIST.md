# Pre-Public Checklist

Tasks to complete before flipping `prinsmike/nvim` from private to public.
Modelled on the already-configured public repos
[`azure-talos-clusters`](https://github.com/prinsmike/azure-talos-clusters)
(Dependabot, CI checks, PR template, CODEOWNERS) and
[`passgo`](https://github.com/prinsmike/passgo) (README status badges,
tag-triggered release workflow with CHANGELOG-derived notes).

> This file is a working tracker — delete it (or move it out of the repo) once
> everything below is done, so it doesn't ship in the public config.

---

## 1. Legal / licensing — **blocker**

- [x] **Add a `LICENSE` file.** Added **MIT** (© 2026 Mike Prinsloo), matching `azure-talos-clusters`.
- [x] Update the README **License** section to name the licence and link `LICENSE`.
- [ ] Confirm GitHub detects the licence in the repo sidebar after the merge.

## 2. Repository hygiene / secrets — **blocker**

- [ ] Scan history for anything private before going public: absolute paths,
      hostnames, tokens, machine-specific data. (`git log -p`, or a scanner like
      `gitleaks`.) History is public once the repo is.
- [x] **Add a `.gitignore`** — added (`*.local`, editor/OS clutter, spell `.add.spl`).
- [x] Confirm `lazy-lock.json` is intentionally tracked (it is, per CHANGELOG 0.4.0). ✔

## 3. `.github/` — CI, automation, governance

The repo had **no `.github/` directory at all**. Added:

- [x] **`.github/workflows/ci.yml`** — `stylua --check .` (via `stylua.toml`: tabs,
      width 2) + `luacheck` on push/PR. Existing Lua reformatted so it's green.
- [x] **`.github/workflows/release.yml`** — tag-triggered, `verify-changelog` gate,
      GitHub release created with the matching CHANGELOG section as notes. No binary
      build (it's a config). **TODO: existing tags v0.1.0–v0.5.0 have no GitHub
      releases — decide whether to backfill** (the workflow only fires on new tags).
- [x] **`.github/dependabot.yml`** — `github-actions` group, weekly,
      `chore(deps)` prefix. **Still TODO: enable Dependabot _security_ updates in repo settings.**
- [x] **`.github/pull_request_template.md`** — summary + checklist + reviewer notes.
- [x] **`.github/CODEOWNERS`** — `* @prinsmike`.
- [ ] *(Optional)* Issue templates (`.github/ISSUE_TEMPLATE/`) — lower priority.

## 4. README polish

- [x] **Add status badges** at the top: CI status, latest release, License (MIT).
- [x] Fix the **License** section (see §1).
- [ ] Sanity-check that documented prerequisites, keybindings, and structure still
      match the code (README is currently detailed and looks current).

## 5. Agent / contributor docs — done in this branch

- [x] **`AGENTS.md`** — concise agent/contributor guide with the project-wide workflow
      rules (branch for new work, atomic commits, PR + human review, CHANGELOG before release).
- [x] **`CLAUDE.md`** — thin file that imports `AGENTS.md` via `@AGENTS.md`.
- [ ] *(Optional)* A short `CONTRIBUTING.md` pointing external contributors at `AGENTS.md`.

## 6. Repository settings (GitHub UI — do at flip time)

- [ ] Set a clear **description** and topics (`neovim`, `lazy-nvim`, `dotfiles`,
      `lua`, `lsp`). Current description: *"My Neovim configuration."*
- [ ] Enable branch protection on `main`: require the CI check + a PR before merge
      (aligns with the AGENTS.md workflow).
- [ ] Restrict Actions permissions (read-only token; allowlist if desired, as in
      `azure-talos-clusters`).
- [ ] Decide on Issues / Discussions / Wiki visibility.
- [ ] **Flip to public.**

---

### Suggested order

1. §1 licence + §2 secrets/hygiene (blockers).
2. §3 `.github/` CI + release + dependabot + PR template + CODEOWNERS.
3. §4 README badges & licence section.
4. §6 repo settings, then flip public.

Each numbered group is a good unit of work for its own branch + PR.
