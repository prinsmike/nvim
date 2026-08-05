#!/bin/sh
#
# Shared build step for the example Dockerfiles: create the agent user with the
# host's UID/GID, then install Claude Code as that user.
#
# Runs as root at build time on any Debian-derived base image. The build args
# AGENT_UID, AGENT_GID and CLAUDE_VERSION reach it as environment variables.

set -eu

AGENT_UID=${AGENT_UID:-1000}
AGENT_GID=${AGENT_GID:-1000}
CLAUDE_VERSION=${CLAUDE_VERSION:-latest}

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y --no-install-recommends \
	bash \
	ca-certificates \
	curl \
	git \
	less \
	openssh-client \
	procps \
	ripgrep \
	socat

# The GitHub CLI, from GitHub's own apt repository. The agent needs it to open
# and review pull requests; scripts/claude-container supplies the token.
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
	-o /usr/share/keyrings/githubcli-archive-keyring.gpg
chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
printf 'deb [arch=%s signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main\n' \
	"$(dpkg --print-architecture)" >/etc/apt/sources.list.d/github-cli.list
apt-get update
apt-get install -y --no-install-recommends gh

rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------------------------
# The agent user.
#
# Its UID/GID must match the host user's, so that files written into the bind
# mounted repository come out owned by the person running Neovim. Some base
# images already ship a user at UID 1000 (node, for one); remove it rather than
# leaving two names fighting over the same UID.
# ---------------------------------------------------------------------------

existing_user=$(getent passwd "$AGENT_UID" | cut -d: -f1 || true)
if [ -n "$existing_user" ] && [ "$existing_user" != agent ]; then
	userdel -r "$existing_user" 2>/dev/null || userdel "$existing_user"
fi

if ! getent group "$AGENT_GID" >/dev/null 2>&1; then
	groupadd -g "$AGENT_GID" agent
fi
agent_group=$(getent group "$AGENT_GID" | cut -d: -f1)

useradd -m -d /home/agent -u "$AGENT_UID" -g "$agent_group" -s /bin/bash agent

# Create the bind mount target so it exists with the right ownership even if the
# container is started without the mount.
mkdir -p /home/agent/.claude
chown -R "$AGENT_UID:$AGENT_GID" /home/agent

# ---------------------------------------------------------------------------
# Claude Code.
#
# Installed as the agent user, so the native installer's ~/.local layout lands
# in a home the runtime user owns. Auto-updates are disabled at runtime by
# scripts/claude-container: in an ephemeral container an update would be
# re-downloaded every session and thrown away. Update by rebuilding the image
# with `scripts/claude-container --container-rebuild`.
# ---------------------------------------------------------------------------

su agent -s /bin/sh -c "
	set -eu
	export HOME=/home/agent
	curl -fsSL https://claude.ai/install.sh | bash -s '$CLAUDE_VERSION'
"

test -x /home/agent/.local/bin/claude ||
	{ echo 'setup.sh: Claude Code did not install' >&2; exit 1; }
