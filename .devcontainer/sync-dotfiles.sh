#!/usr/bin/env bash
set -euo pipefail

DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/mxvoloshin/dotfiles.git}"
DOTFILES_DIR="${HOME}/.dotfiles"

log() { echo "[dotfiles-sync] $*"; }

if [[ ! -d "${DOTFILES_DIR}/.git" ]]; then
  log "Cloning ${DOTFILES_REPO} into ${DOTFILES_DIR}"
  git clone --depth 1 "${DOTFILES_REPO}" "${DOTFILES_DIR}"
else
  log "Updating ${DOTFILES_DIR}"
  git -C "${DOTFILES_DIR}" pull --ff-only --quiet || {
    log "Pull failed (non-fast-forward or network). Skipping update this run."
  }
fi

apply_link() {
  local src="$1"
  local dest="$2"

  if [[ -f "${src}" ]]; then
    ln -sfn "${src}" "${dest}"
    log "Linked $(basename "${dest}")"
  else
    log "Skip $(basename "${dest}") (not found in repo)"
  fi
}

# Always apply tmux config
apply_link "${DOTFILES_DIR}/.tmux.conf" "${HOME}/.tmux.conf"

# Apply zsh config (repo currently has this)
apply_link "${DOTFILES_DIR}/.zshrc" "${HOME}/.zshrc"

# Optional ash config (if you add it later)
apply_link "${DOTFILES_DIR}/.ashrc" "${HOME}/.ashrc"

# Ensure zoxide init exists in active zshrc
if [[ -f "${HOME}/.zshrc" ]] && ! grep -q "zoxide init zsh" "${HOME}/.zshrc"; then
  {
    echo ""
    echo "# zoxide"
    echo "eval \"$(zoxide init zsh)\""
  } >> "${HOME}/.zshrc"
  log "Appended zoxide init to .zshrc"
fi

log "Done"
