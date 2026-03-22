FROM mcr.microsoft.com/dotnet/sdk:10.0-preview

ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

ENV DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      zsh tmux curl wget jq unzip zip ca-certificates sudo \
      fd-find nodejs npm \
      build-essential gettext libssl-dev libcurl4-gnutls-dev libexpat1-dev zlib1g-dev; \
    \
    # Git (latest)
    GIT_VERSION="$(curl -fsSL https://api.github.com/repos/git/git/releases/latest | jq -r '.tag_name' | sed 's/^v//')"; \
    curl -fsSL "https://www.kernel.org/pub/software/scm/git/git-${GIT_VERSION}.tar.gz" -o /tmp/git.tar.gz; \
    tar -xzf /tmp/git.tar.gz -C /tmp; \
    cd "/tmp/git-${GIT_VERSION}"; \
    make prefix=/usr/local all -j"$(nproc)"; \
    make prefix=/usr/local install; \
    \
    # Neovim (latest release binary)
    NVIM_TAG="$(curl -fsSL https://api.github.com/repos/neovim/neovim/releases/latest | jq -r '.tag_name')"; \
    curl -fsSL "https://github.com/neovim/neovim/releases/download/${NVIM_TAG}/nvim-linux-x86_64.tar.gz" -o /tmp/nvim.tar.gz; \
    rm -rf /opt/nvim; \
    mkdir -p /opt/nvim; \
    tar -xzf /tmp/nvim.tar.gz --strip-components=1 -C /opt/nvim; \
    ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim; \
    \
    # ripgrep (latest release binary)
    RG_ASSET="$(curl -fsSL https://api.github.com/repos/BurntSushi/ripgrep/releases/latest | jq -r '.assets[] | select(.name | test("x86_64-unknown-linux-musl.tar.gz$")) | .browser_download_url' | head -n1)"; \
    curl -fsSL "$RG_ASSET" -o /tmp/rg.tar.gz; \
    tar -xzf /tmp/rg.tar.gz -C /tmp; \
    RG_DIR="$(find /tmp -maxdepth 1 -type d -name 'ripgrep-*' | head -n1)"; \
    install -m 0755 "$RG_DIR/rg" /usr/local/bin/rg; \
    \
    # fzf (latest release binary)
    FZF_ASSET="$(curl -fsSL https://api.github.com/repos/junegunn/fzf/releases/latest | jq -r '.assets[] | select(.name | test("linux_amd64.tar.gz$")) | .browser_download_url' | head -n1)"; \
    curl -fsSL "$FZF_ASSET" -o /tmp/fzf.tar.gz; \
    tar -xzf /tmp/fzf.tar.gz -C /usr/local/bin fzf; \
    chmod +x /usr/local/bin/fzf; \
    \
    # CLIs
    npm install -g opencode-ai@latest @openai/codex@latest @github/copilot@latest; \
    \
    # Cleanup
    rm -rf /var/lib/apt/lists/* /tmp/*

RUN if ! getent group ${USER_GID} >/dev/null; then groupadd --gid ${USER_GID} ${USERNAME}; fi \
    && if ! id -u ${USERNAME} >/dev/null 2>&1; then useradd --uid ${USER_UID} --gid ${USER_GID} -m -s /usr/bin/zsh ${USERNAME}; fi \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

USER ${USERNAME}
WORKDIR /workspace
