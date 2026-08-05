# Go toolchain plus Claude Code.
#
# gopls is deliberately absent: the language server runs on the host, driven by
# nvim-lspconfig. This image only needs what the agent invokes itself — build,
# test, vet, and the linters and formatters it is likely to reach for.

FROM golang:1.26

ARG AGENT_UID=1000
ARG AGENT_GID=1000
ARG CLAUDE_VERSION=latest

COPY setup.sh /tmp/setup.sh
RUN /tmp/setup.sh && rm /tmp/setup.sh

# The stock image points GOPATH at /go, which root owns. Move it into the agent's
# home so `go install` and the module cache work without root.
ENV GOPATH=/home/agent/go
ENV GOMODCACHE=/home/agent/go/pkg/mod
ENV GOCACHE=/home/agent/.cache/go-build
ENV PATH=/home/agent/.local/bin:/home/agent/go/bin:$PATH

USER agent
WORKDIR /home/agent

RUN go install golang.org/x/tools/cmd/goimports@latest \
	&& go install honnef.co/go/tools/cmd/staticcheck@latest \
	&& go clean -cache -testcache

CMD ["claude"]
