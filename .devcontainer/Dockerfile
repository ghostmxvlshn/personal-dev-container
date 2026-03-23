FROM mcr.microsoft.com/dotnet/sdk:10.0

ARG USERNAME=dev
ARG USER_UID=1001
ARG USER_GID=${USER_UID}

ENV DEBIAN_FRONTEND=noninteractive

# Pinned CLI/tool versions for reproducible builds
ARG OPENCODE_VERSION=1.2.27
ARG CODEX_VERSION=0.116.0
ARG COPILOT_VERSION=1.0.10
ARG PNPM_VERSION=10.32.1
ARG TYPESCRIPT_VERSION=5.9.3
ARG TSX_VERSION=4.21.0
ARG ESLINT_VERSION=10.1.0
ARG PRETTIER_VERSION=3.8.1

# Pin system/tooling versions (avoid "latest" lookups during build)
ARG GIT_VERSION=2.49.0
ARG NVIM_TAG=v0.11.4
ARG RIPGREP_VERSION=15.1.0
ARG FZF_VERSION=0.66.0

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      zsh tmux git curl wget jq unzip zip ca-certificates sudo gnupg \
      fd-find gh zoxide \
      zsh-autosuggestions zsh-syntax-highlighting \
      build-essential gettext libssl-dev libcurl4-gnutls-dev libexpat1-dev zlib1g-dev; \
    \
    # Node.js 22 LTS (NodeSource)
    mkdir -p /etc/apt/keyrings; \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg; \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_22.x nodistro main" > /etc/apt/sources.list.d/nodesource.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends nodejs; \
    \
    # Git (pinned upstream release)
    curl -fsSL "https://www.kernel.org/pub/software/scm/git/git-${GIT_VERSION}.tar.gz" -o /tmp/git.tar.gz; \
    tar -xzf /tmp/git.tar.gz -C /tmp; \
    cd "/tmp/git-${GIT_VERSION}"; \
    make prefix=/usr/local all -j"$(nproc)"; \
    make prefix=/usr/local install; \
    \
    # Neovim (pinned release binary)
    curl -fsSL "https://github.com/neovim/neovim/releases/download/${NVIM_TAG}/nvim-linux-x86_64.tar.gz" -o /tmp/nvim.tar.gz; \
    rm -rf /opt/nvim; \
    mkdir -p /opt/nvim; \
    tar -xzf /tmp/nvim.tar.gz --strip-components=1 -C /opt/nvim; \
    ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim; \
    \
    # ripgrep (pinned release binary)
    curl -fsSL "https://github.com/BurntSushi/ripgrep/releases/download/${RIPGREP_VERSION}/ripgrep-${RIPGREP_VERSION}-x86_64-unknown-linux-musl.tar.gz" -o /tmp/rg.tar.gz; \
    tar -xzf /tmp/rg.tar.gz -C /tmp; \
    install -m 0755 "/tmp/ripgrep-${RIPGREP_VERSION}-x86_64-unknown-linux-musl/rg" /usr/local/bin/rg; \
    \
    # fzf (pinned release binary)
    curl -fsSL "https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-linux_amd64.tar.gz" -o /tmp/fzf.tar.gz; \
    tar -xzf /tmp/fzf.tar.gz -C /usr/local/bin fzf; \
    chmod +x /usr/local/bin/fzf; \
    \
    # CLIs + TypeScript baseline tooling (pinned)
    npm install -g \
      opencode-ai@${OPENCODE_VERSION} @openai/codex@${CODEX_VERSION} @github/copilot@${COPILOT_VERSION} \
      pnpm@${PNPM_VERSION} typescript@${TYPESCRIPT_VERSION} tsx@${TSX_VERSION} \
      eslint@${ESLINT_VERSION} prettier@${PRETTIER_VERSION}; \
    \
    # Cleanup
    rm -rf /var/lib/apt/lists/* /tmp/*

RUN if ! getent group ${USER_GID} >/dev/null; then groupadd --gid ${USER_GID} ${USERNAME}; fi \
    && if ! id -u ${USERNAME} >/dev/null 2>&1; then useradd --uid ${USER_UID} --gid ${USER_GID} -m -s /usr/bin/zsh ${USERNAME}; fi \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

# Make .NET global tools available in all shells/processes
ENV PATH="/home/dev/.dotnet/tools:${PATH}"

USER ${USERNAME}
WORKDIR /workspace
