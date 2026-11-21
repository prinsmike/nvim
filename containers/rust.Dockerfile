# Rust toolchain plus Claude Code.
#
# rust-analyzer is deliberately absent: it runs on the host under rustaceanvim,
# and checks into target/rust-analyzer so that it never waits on, or holds, the
# build directory lock that the agent's cargo takes on target/. This image only
# needs what the agent invokes itself: build, test, clippy and rustfmt.
#
# The tag follows the newest stable release. A project that pins a toolchain in
# rust-toolchain.toml gets that one instead: rustup installs it on first use,
# which works because the stock image leaves /usr/local/rustup world-writable.

FROM rust:1

ARG AGENT_UID=1000
ARG AGENT_GID=1000
ARG CLAUDE_VERSION=latest

COPY setup.sh /tmp/setup.sh
RUN /tmp/setup.sh && rm /tmp/setup.sh

# The stock image keeps cargo's home in /usr/local/cargo. Move it into the
# agent's home, so `cargo install` output and the registry cache live somewhere
# that can be bind-mounted from the host. The toolchain stays in
# /usr/local/rustup, reached through the proxies in /usr/local/cargo/bin, which
# the base image already has on PATH.
ENV CARGO_HOME=/home/agent/.cargo
ENV PATH=/home/agent/.local/bin:/home/agent/.cargo/bin:$PATH

USER agent
WORKDIR /home/agent

# The stock image installs rustup's minimal profile, which has neither clippy
# nor rustfmt. cargo-nextest is built from source so that the image is not tied
# to one architecture; the registry cache the build leaves behind is dropped.
RUN rustup component add clippy rustfmt \
	&& cargo install --locked cargo-nextest \
	&& rm -rf /home/agent/.cargo/registry /home/agent/.cargo/git

CMD ["claude"]
