# Terraform toolchain plus Claude Code.
#
# No language server here, for the usual reason: the LSP client is Neovim on the
# host, so terraform-ls belongs there rather than in this image. `fmt` and
# `validate` come with the CLI; tflint, terraform-docs and trivy cover the rest
# of what a Terraform repository's CI normally runs.
#
# Nothing in this image grants cloud access, and that is deliberate — see the
# note on credentials in containers/README.md before mounting any.

FROM debian:bookworm-slim

ARG AGENT_UID=1000
ARG AGENT_GID=1000
ARG CLAUDE_VERSION=latest

# Pinned, so that a bump is a visible change to this file — and, because the
# image tag hashes the file, one that rebuilds on the next session. Terraform
# and trivy track their apt repositories instead.
ARG TFLINT_VERSION=0.64.0
ARG TERRAFORM_DOCS_VERSION=0.24.0

COPY setup.sh /tmp/setup.sh
RUN /tmp/setup.sh && rm /tmp/setup.sh

# Terraform and trivy, from their vendors' apt repositories. Both signing keys
# are ASCII-armoured, so `signed-by` reads them as-is and gnupg stays out of the
# image.
RUN set -eux; \
	arch=$(dpkg --print-architecture); \
	curl -fsSL https://apt.releases.hashicorp.com/gpg \
		-o /usr/share/keyrings/hashicorp.asc; \
	curl -fsSL https://get.trivy.dev/deb/public.key \
		-o /usr/share/keyrings/trivy.asc; \
	chmod go+r /usr/share/keyrings/hashicorp.asc /usr/share/keyrings/trivy.asc; \
	printf 'deb [arch=%s signed-by=/usr/share/keyrings/hashicorp.asc] https://apt.releases.hashicorp.com bookworm main\n' \
		"$arch" >/etc/apt/sources.list.d/hashicorp.list; \
	printf 'deb [arch=%s signed-by=/usr/share/keyrings/trivy.asc] https://get.trivy.dev/deb bookworm main\n' \
		"$arch" >/etc/apt/sources.list.d/trivy.list; \
	apt-get update; \
	apt-get install -y --no-install-recommends terraform trivy unzip; \
	rm -rf /var/lib/apt/lists/*

# tflint and terraform-docs ship as release archives rather than packages. Both
# projects name their assets by dpkg architecture, so amd64 and arm64 hosts both
# build without a lookup table.
RUN set -eux; \
	arch=$(dpkg --print-architecture); \
	curl -fsSL -o /tmp/tflint.zip \
		"https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_${arch}.zip"; \
	unzip -d /usr/local/bin /tmp/tflint.zip; \
	curl -fsSL -o /tmp/terraform-docs.tar.gz \
		"https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-${arch}.tar.gz"; \
	tar -xzf /tmp/terraform-docs.tar.gz -C /usr/local/bin terraform-docs; \
	chmod +x /usr/local/bin/tflint /usr/local/bin/terraform-docs; \
	rm /tmp/tflint.zip /tmp/terraform-docs.tar.gz; \
	tflint --version; \
	terraform-docs --version

# Provider and plugin caches, in a home the agent owns. Terraform refuses to use
# TF_PLUGIN_CACHE_DIR unless the directory already exists. Both are ephemeral
# unless the project mounts them — see .claude-container.example.
RUN set -eux; \
	mkdir -p /home/agent/.terraform.d/plugin-cache /home/agent/.tflint.d/plugins; \
	chown -R "$AGENT_UID:$AGENT_GID" /home/agent/.terraform.d /home/agent/.tflint.d

ENV PATH=/home/agent/.local/bin:$PATH
ENV TF_PLUGIN_CACHE_DIR=/home/agent/.terraform.d/plugin-cache
ENV TFLINT_PLUGIN_DIR=/home/agent/.tflint.d/plugins

USER agent
WORKDIR /home/agent
CMD ["claude"]
