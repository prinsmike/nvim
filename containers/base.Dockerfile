# Minimal image: Claude Code, git, ripgrep and nothing else.
#
# The default when a project asks for a container without naming a variant.
# Copy this file to add a toolchain for a language not covered here.

FROM debian:bookworm-slim

ARG AGENT_UID=1000
ARG AGENT_GID=1000
ARG CLAUDE_VERSION=latest

COPY setup.sh /tmp/setup.sh
RUN /tmp/setup.sh && rm /tmp/setup.sh

ENV PATH=/home/agent/.local/bin:$PATH

USER agent
WORKDIR /home/agent
CMD ["claude"]
