# Design: containerised Claude Code

Status: implemented
Applies to: `scripts/claude-container`, `containers/`, `lua/prinsmike/plugins/claudecode.lua`

## Summary

Run the `claude` CLI inside a container that can see only the repository you are
working in, while Neovim keeps running on the host. The integration between the
two — diffs, `@`-mentions, selection context — must keep working exactly as it
does today.

The launcher is opt-in per project. With no configuration present it execs the
host's `claude`, so cloning this configuration changes nothing for anyone who
does not ask for a container.

## Background: how Neovim and Claude Code talk

This design is shaped almost entirely by the transport, so it is worth stating
precisely. Neovim is the server, not the client:

1. `claudecode.nvim` starts a WebSocket server bound to `127.0.0.1` on a random
   port. The bind address is hardcoded (`lua/claudecode/server/tcp.lua`), so it
   is never reachable from another network namespace.
2. It writes a lock file to `$CLAUDE_CONFIG_DIR/ide/<port>.lock` containing the
   port (as the filename), the `workspaceFolders` list, and an `authToken`. The
   token exists only in that file, and the server rejects any handshake that
   does not present it.
3. It spawns `terminal_cmd` (default `claude`) in a terminal split with
   `ENABLE_IDE_INTEGRATION`, `FORCE_CODE_TERMINAL` and `CLAUDE_CODE_SSE_PORT`
   in the environment.
4. Thereafter the two exchange JSON-RPC over that socket. **Every file
   reference in both directions is an absolute path.**

Point 4 is the one that dictates the whole design, and it is the trap most
"put the agent in a container" setups fall into. If the repository is mounted
at `/workspace` inside the container, then `openDiff` arrives at Neovim naming
`/workspace/lua/init.lua`, which does not exist on the host, and a selection
sent from Neovim names a host path that does not exist in the container. Diffs
silently open empty buffers and `@`-mentions resolve to nothing.

## Goals

- Claude Code can read and write only the current repository.
- The IDE integration keeps working: diffs, selections, `@`-mentions, model
  picker.
- Two accounts (personal and work) stay strictly separated.
- Everything needed lives in this repository, so `terminal_cmd` never points at
  a file that a fresh clone does not have.
- Per-project-type images, so a Go project gets a Go toolchain.
- No container unless the user asks for one.

## Non-goals

- Replacing the host Neovim. This is not a devcontainer: the editor, LSP servers
  and formatters stay on the host, and only the agent is confined.
- Defending against a container escape. The threat model is an agent that
  wanders outside its repository or reads unrelated credentials, not a hostile
  kernel exploit.
- Outbound network allowlisting. See [Limitations](#limitations).

## Design

### Path identity

**The repository is mounted at the same absolute path inside the container as
it has on the host.** `-v "$PWD:$PWD" -w "$PWD"`. This is not a convenience;
it is what makes the protocol work at all, and it is the single rule a
project-supplied image must not break.

`git_repo_cwd = true` is already set in the plugin spec, so the terminal's
working directory is the repository root and `$PWD` is the correct mount source
with no extra work.

### Everything else is decoupled

Only the project path has to match. In particular the container's `HOME` does
*not*, and deliberately does not: the images use a fixed `/home/agent`, and the
host's Claude configuration directory is mounted there as `/home/agent/.claude`
regardless of where it lives on the host. That keeps the images generic — they
contain no reference to any particular user's home directory — and it means a
repository living under `/home/<user>/...` simply appears at that path in the
container alongside `/home/agent`, with no conflict.

The lock file survives this translation because nothing in it is
home-relative: it carries a port, a token, a pid, and the workspace folder,
and the workspace folder matches by the rule above.

### Networking

Two constraints collide here. Claude Code dials `127.0.0.1:$CLAUDE_CODE_SSE_PORT`,
and Neovim's server is bound to the *host's* `127.0.0.1`. Whatever we do, the
container's own loopback has to end up carrying that connection.

**`host` (default).** Share the host's network namespace, and the two loopbacks
are the same interface. Nothing else is required.

The cost is worth stating plainly: the container can then reach every service
listening on host loopback — local databases, other Neovim instances' IDE
sockets, anything bound to `127.0.0.1`.

**`bridge`.** Put the agent on its own namespace and forward exactly one port
into it. This takes two hops, and the obvious one-hop version does not work:

```
claude → 127.0.0.1:PORT        (agent container, own namespace)
       → entrypoint socat      → host.docker.internal:PORT
       → relay sidecar         (host namespace, bound to 172.17.0.1:PORT)
       → 127.0.0.1:PORT        (the editor)
```

A container-side `socat` alone cannot reach the editor. It would dial the
bridge gateway address, and a server bound to `127.0.0.1` does not accept
connections addressed to `172.17.0.1` — the connection is refused. Something
in the host's namespace has to bridge the two addresses.

That something is a sidecar container: the launcher starts one on
`--network host` running nothing but `socat`, binding the gateway address and
forwarding to loopback. It is removed when the session ends. Using a container
rather than a host process keeps the host dependency-free — `socat` only has to
exist in the image.

So `bridge` does not eliminate host-namespace access; it reduces it to a
process that forwards a single port. In exchange the agent itself cannot reach
host loopback at all. The residual exposure is that the editor port is
reachable by other containers on the default bridge for the length of the
session, still gated by the lock file's auth token.

### Opt-in and fallback

Resolution order, first match wins:

1. `CLAUDE_CONTAINER` in the environment. `0`, `off`, `no`, `false` or `host`
   force the host binary; any other value names a variant or an image.
2. A `.claude-container` file at the repository root.
3. Neither: exec the host `claude`, unchanged.

The decision lives in the launcher rather than in Lua, which is why the
fallback is free: `terminal_cmd` always points at the launcher, and the
launcher decides. There is no toggle to forget and no second code path in the
plugin spec.

`.claude-container` is a flat `key=value` file. It is parsed line by line and
never sourced or `eval`'d, so a hostile repository cannot get code execution
out of a file whose whole purpose is to be read before the agent starts.

```ini
# Build containers/go.Dockerfile and run in it.
variant=go

# Optional.
network=bridge
mount=~/go/pkg/mod:/home/agent/go/pkg/mod:ro
env=GOFLAGS
```

Recognised keys: `variant`, `image`, `dockerfile`, `network`, `mount` (repeatable),
`env` (repeatable), `home`, `user`.

### Images

`variant=go` resolves to `containers/go.Dockerfile`, built on demand. The image
is tagged with a hash of the Dockerfile contents, the setup script, and the
host UID/GID:

```
claude-container/go:4f2a1b9c8e7d
```

Editing the Dockerfile changes the tag, so the next session rebuilds
automatically and there is no stale-image failure mode. Building for a
different UID produces a different tag rather than an image full of
wrongly-owned files.

Claude Code's auto-updater is disabled in the images. In an ephemeral container
it would re-download on every session and throw the result away. Updating is a
rebuild: `scripts/claude-container --container-rebuild`.

### Image contract

Any image — shipped, project-supplied, or third-party — must provide:

- a user whose UID/GID match the host user's, with home `/home/agent`
- `claude` on `PATH`
- `sh` and `git`
- `socat`, only for `network=bridge`

The entrypoint is **not** baked into the image. It is bind-mounted read-only
from `containers/entrypoint.sh` and selected with `--entrypoint`, which means
an image built for something else entirely can be pressed into service without
modification, and fixing the entrypoint does not invalidate every image.

### What is mounted

| Source                     | Destination            | Mode | When |
| -------------------------- | ---------------------- | ---- | ---- |
| repository root            | identical path         | rw   | always |
| `$CLAUDE_CONFIG_DIR`       | `/home/agent/.claude`  | rw   | always |
| `~/.claude.json`           | `/home/agent/.claude/.claude.json` | rw | when `CLAUDE_CONFIG_DIR` is unset |
| `~/.gitconfig`             | `/home/agent/.gitconfig` | ro | when it exists |
| `containers/entrypoint.sh` | `/usr/local/bin/claude-entrypoint` | ro | always |
| `$SSH_AUTH_SOCK`           | `/run/ssh-agent.sock`  | rw   | `ssh=agent` |
| `~/.ssh/known_hosts`       | `/home/agent/.ssh/known_hosts` | ro | `ssh=agent` |

Nothing else. Notably **not** `~/.ssh` itself and **not** the Docker socket —
mounting the latter would hand the container root on the host and make the
entire exercise theatre.

`.claude.json` needs explaining. It holds onboarding state, trust decisions and
per-project history, and Claude Code keeps it *inside* `CLAUDE_CONFIG_DIR` when
that variable is set but at `~/.claude.json` when it is not. The container
always runs with it set, so on a host where it is unset the file sits outside
the mounted directory and has to be carried in on its own. Without that, the
container starts against a blank configuration and writes a stub into the
mounted directory.

## Authentication

Nothing authenticates inside the container. Every credential is established on
the host and reaches the container as either a mount or a token, which is what
keeps the browser flows working — a container has no browser to open.

### Claude Code

A Max subscription authenticates over OAuth, and the tokens live in
`$CLAUDE_CONFIG_DIR/.credentials.json` on Linux — inside the directory already
mounted read-write. So the container uses the subscription, not the API, and
incurs no API costs. Refreshed tokens are written back through the mount and
persist on the host.

There is no need to set `ANTHROPIC_API_KEY`, and setting one would be a
downgrade: it bills per token instead of using the subscription.

The browser flow only matters when there is no valid token to inherit — a first
login, or a fully expired refresh token. Run `claude` on the host and log in
there; the container picks up the result on its next session.

### GitHub CLI

`gh` stores its token in the system keyring by default, not in
`~/.config/gh/hosts.yml`. Mounting the gh configuration directory therefore
carries no credentials at all — this was verified, not assumed.

So `github=token` asks the host at launch instead: the launcher runs
`gh auth token` and passes the result as `GH_TOKEN`. The container then has a
working `gh` for reviewing and opening pull requests, with the same scopes the
host account has.

The token is passed as an environment variable, so it is visible to anything
that can query the Docker daemon. On a single-user machine that is already
root-equivalent, but it is a real difference from the SSH arrangement below,
where no secret crosses the boundary at all.

### SSH

`ssh=agent` bind-mounts `$SSH_AUTH_SOCK` rather than any key. The container can
ask the agent to sign, but the private key never crosses the boundary — with
`~/.ssh` unmounted there is nothing to read. `known_hosts` comes along read-only,
without which every push would stop at an unknown-host prompt.

The limit worth understanding: forwarding an agent grants use of **every key
loaded into it**. Separation between accounts is therefore a property of which
agent is forwarded, not something the launcher can filter.

Repositories whose remotes use `~/.ssh/config` host aliases need that file too,
since aliases are resolved client-side:

```ini
mount=~/.ssh/config:/home/agent/.ssh/config:ro
```

Plain `git@github.com:owner/repo.git` remotes need nothing extra: the user comes
from the URL and the key from the agent.

### Putting it together: two accounts

An account is defined by three environment variables, all of them inherited by
the launcher from whatever environment Neovim was started in:

| Variable            | Decides                        |
| ------------------- | ------------------------------ |
| `CLAUDE_CONFIG_DIR` | which Claude subscription      |
| `SSH_AUTH_SOCK`     | which SSH keys are usable      |
| `GH_CONFIG_DIR`     | which GitHub account `gh` uses |

A wrapper per account keeps them in step:

```bash
#!/usr/bin/env bash
# nvim-work
export CLAUDE_CONFIG_DIR="$HOME/.claude-work"
export GH_CONFIG_DIR="$HOME/.config/gh-work"
export SSH_AUTH_SOCK="$HOME/.ssh/agent-work.sock"
exec nvim "$@"
```

The work agent should hold only the work key. Forwarding one agent that holds
both keys would let the work container push as the personal identity, which is
exactly the boundary the separate configuration directories exist to draw.

The configuration directory is mounted read-write because Claude Code writes
session history and project state there. It necessarily contains that account's
credentials, which is the reason account separation is done by mounting
*different* directories rather than by trying to filter one.

### Two accounts

`claudecode.nvim` reads `CLAUDE_CONFIG_DIR` when deciding where to write the
lock file (`lua/claudecode/lockfile.lua`), and the launcher forwards the same
value into the container. So the account is chosen by the environment Neovim
was started in:

```bash
# personal — the default
nvim

# work
CLAUDE_CONFIG_DIR=~/.claude-work nvim
```

The work container mounts `~/.claude-work` and never sees `~/.claude`, or the
reverse. Neither can read the other's credentials, and session history does not
mix.

## Security trade-offs

What this buys:

- The agent cannot read `~/.ssh`, other repositories, browser profiles, shell
  history, or the other account's credentials. With `ssh=agent` it can use your
  keys without ever being able to read them.
- Writes land as your UID inside the one directory you mounted.
- Anything the agent installs dies with the container.

What it does not buy:

- Isolation from host loopback services, under the default `host` network mode.
  `network=bridge` does buy this.
- Any restriction on outbound network access, in either mode.
- Protection against a container escape, which is not the threat model.
- Any narrowing of what the forwarded credentials can do. A `GH_TOKEN` carries
  the host account's full scopes, and a forwarded agent carries every key it
  holds. Both are all-or-nothing, and both default to off.

An honest summary: this is a meaningful reduction in blast radius, not a
sandbox in the security-boundary sense.

## Alternatives considered

**Claude Code's built-in bubblewrap sandbox.** The binary ships one — `sandbox`
settings including `sandboxDenyPaths` and `autoAllowBashIfSandboxed`, and
`bwrap` is already installed on this machine. It confines the filesystem with
no container at all, and since it runs on the same machine the IDE integration
needs no plumbing whatsoever. It is the better choice if the only goal is "stop
the agent leaving this repository". It was not chosen here because it gives no
per-account boundary and no per-project toolchain, both of which were explicit
requirements.

**Mounting at a fixed path such as `/workspace`.** Rejected: it breaks the
protocol, as set out above. Translating paths in a proxy between the two was
considered and rejected as far more machinery than mounting at the right path.

**Binding the Neovim WebSocket server to `0.0.0.0`.** Would let a bridged
container connect directly without `socat`, but the bind address is hardcoded
upstream, and exposing an authenticated-but-local editor control socket to the
network is a bad trade for removing one process.

**A full devcontainer with Neovim inside.** A different product: it isolates the
whole environment rather than the agent, and gives up the host editor, its LSP
servers, and the terminal integration.

## Limitations

- **Git worktrees and submodules.** If `.git` is a file pointing outside the
  repository root, the container cannot follow it. Git operations will fail.
- **`--add-dir` outside the root.** Extra directories are not mounted
  automatically; add a `mount=` line.
- **Symlinks leaving the root** dangle inside the container.
- **Egress is unrestricted.** An allowlisting firewall (`NET_ADMIN` plus
  iptables rules in the entrypoint, permitting the Anthropic API and little
  else) is the obvious next step and is not implemented.
- **Old image tags accumulate.** Content-hashed tags mean editing a Dockerfile
  builds a new image and leaves the previous one behind. Clear them out with
  `docker image prune --filter label=... ` or, more bluntly,
  `docker images 'claude-container/*' -q | xargs -r docker rmi`.
- **Linux and Docker only.** `host` networking behaves differently on macOS,
  and rootless Docker changes the UID mapping the tagging scheme assumes.
