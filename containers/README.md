# Container images for Claude Code

Example images for running the `claude` CLI confined to a single repository,
built on demand by [`scripts/claude-container`](../scripts/claude-container).
The design and the reasoning behind it are in
[`docs/claude-container.md`](../docs/claude-container.md).

| Variant  | Base                | Adds                                    |
| -------- | ------------------- | --------------------------------------- |
| `base`   | `debian:bookworm-slim` | git, gh, ssh, ripgrep, socat         |
| `go`     | `golang:1.26`       | Go toolchain, goimports, staticcheck    |
| `node`   | `node:22-slim`      | Node.js, npm, corepack (pnpm and yarn)  |
| `python` | `python:3.12-slim`  | CPython, uv, ruff                       |

Select one from a project's `.claude-container` file:

```ini
variant=go
```

Language servers are deliberately absent. gopls, pyright and the rest run on
the host under nvim-lspconfig; only what the agent invokes itself needs to be
in the image.

## Adding a variant

Copy `base.Dockerfile` to `<name>.Dockerfile` in this directory and set
`variant=<name>`. The build context is this directory, so `COPY setup.sh` works,
and the image tag hashes both files — editing either rebuilds on the next
session.

`setup.sh` assumes a Debian-derived base. On a different distribution, replace
the `apt-get` block but keep the rest: the agent user must end up with the
host's UID/GID and a home at `/home/agent`.

## Bringing your own image

A project can point at its own Dockerfile, built with the project root as
context:

```ini
dockerfile=.claude/Dockerfile
```

or at a prebuilt image, which the launcher never tries to build:

```ini
image=ghcr.io/example/dev:latest
```

Either must satisfy the image contract:

- a user whose UID and GID match the host user's, with home `/home/agent`
- `claude` on `PATH`
- `sh` and `git`
- `socat`, only if the project sets `network=bridge`
- `ssh`, only if the project sets `ssh=agent`
- `gh`, only if the project sets `github=token`

The entrypoint is not part of the contract. It is bind-mounted from
`entrypoint.sh` at run time, so images need no awareness of it.

## Updating Claude Code

Auto-updates are switched off, because an ephemeral container would download an
update on every session and discard it. Rebuild instead:

```bash
scripts/claude-container --container-rebuild
```

To pin a version rather than tracking latest, set `CLAUDE_CONTAINER_VERSION`;
it feeds the installer and forms part of the image tag.

```bash
CLAUDE_CONTAINER_VERSION=2.1.221 scripts/claude-container --container-build
```
