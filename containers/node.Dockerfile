# Node.js toolchain plus Claude Code.
#
# The base image ships a `node` user at UID 1000; setup.sh removes it so the
# agent user can take the host's UID unambiguously.

FROM node:22-slim

ARG AGENT_UID=1000
ARG AGENT_GID=1000
ARG CLAUDE_VERSION=latest

COPY setup.sh /tmp/setup.sh
RUN /tmp/setup.sh && rm /tmp/setup.sh

# corepack provides pnpm and yarn on demand without a global install.
RUN corepack enable

# Global installs go somewhere the agent owns rather than /usr/local/lib.
ENV NPM_CONFIG_PREFIX=/home/agent/.npm-global
ENV PATH=/home/agent/.local/bin:/home/agent/.npm-global/bin:$PATH

USER agent
WORKDIR /home/agent
CMD ["claude"]
