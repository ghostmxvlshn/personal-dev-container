FROM mcr.microsoft.com/dotnet/sdk:10.0-preview

ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    zsh tmux git curl wget jq unzip zip \
    ripgrep fd-find fzf neovim ca-certificates sudo \
    nodejs npm \
    && npm install -g openclaw@latest \
    && rm -rf /var/lib/apt/lists/*

RUN if ! getent group ${USER_GID} >/dev/null; then groupadd --gid ${USER_GID} ${USERNAME}; fi \
    && if ! id -u ${USERNAME} >/dev/null 2>&1; then useradd --uid ${USER_UID} --gid ${USER_GID} -m -s /usr/bin/zsh ${USERNAME}; fi \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

USER ${USERNAME}
WORKDIR /workspace
