#!/bin/sh
#
# Entrypoint for claude-container images.
#
# This file is NOT baked into the image. scripts/claude-container bind-mounts it
# read-only at /usr/local/bin/claude-entrypoint and selects it with --entrypoint,
# so any image satisfying the contract in docs/claude-container.md can be used,
# and fixing the entrypoint does not invalidate every built image.

set -eu

# ---------------------------------------------------------------------------
# Bridge the IDE socket under bridge networking.
#
# claudecode.nvim binds its WebSocket server to the host's 127.0.0.1 and the
# bind address is hardcoded upstream, so with a separate network namespace we
# have to put a listener on the container's loopback at the same port and
# forward it to the host gateway. Under host networking none of this runs: the
# namespace is shared and 127.0.0.1 already is the host.
# ---------------------------------------------------------------------------

if [ -n "${CLAUDE_IDE_BRIDGE_HOST:-}" ] && [ -n "${CLAUDE_CODE_SSE_PORT:-}" ]; then
	port=$CLAUDE_CODE_SSE_PORT

	case $port in
	*[!0-9]* | '')
		printf 'claude-entrypoint: bad CLAUDE_CODE_SSE_PORT: %s\n' "$port" >&2
		exit 1
		;;
	esac

	if ! command -v socat >/dev/null 2>&1; then
		printf 'claude-entrypoint: network=bridge needs socat in the image\n' >&2
		exit 1
	fi

	socat "TCP-LISTEN:$port,bind=127.0.0.1,reuseaddr,fork" \
		"TCP:$CLAUDE_IDE_BRIDGE_HOST:$port" &

	# Wait for the listener before starting claude, which connects on startup.
	# Read /proc/net/tcp rather than dialling the port, so the probe does not
	# open a connection the IDE server would see and immediately lose.
	hexport=$(printf '%04X' "$port")
	i=0
	while [ "$i" -lt 50 ]; do
		if grep -qi ":$hexport " /proc/net/tcp 2>/dev/null; then
			break
		fi
		i=$((i + 1))
		sleep 0.1
	done

	if [ "$i" -eq 50 ]; then
		printf 'claude-entrypoint: socat did not start listening on %s\n' "$port" >&2
		exit 1
	fi
fi

exec "$@"
