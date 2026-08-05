# Python toolchain plus Claude Code.
#
# pyright runs on the host via nvim-lspconfig, so it is not installed here. uv
# covers dependency resolution and virtualenvs; ruff covers linting and
# formatting, matching the host conform.nvim setup.

FROM python:3.12-slim

ARG AGENT_UID=1000
ARG AGENT_GID=1000
ARG CLAUDE_VERSION=latest

COPY setup.sh /tmp/setup.sh
RUN /tmp/setup.sh && rm /tmp/setup.sh

RUN pip install --no-cache-dir --root-user-action=ignore uv ruff

ENV PATH=/home/agent/.local/bin:$PATH
ENV UV_CACHE_DIR=/home/agent/.cache/uv

USER agent
WORKDIR /home/agent
CMD ["claude"]
