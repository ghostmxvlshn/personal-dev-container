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

# Ensure dotnet global tools path exists in active zshrc
if [[ -f "${HOME}/.zshrc" ]] && ! grep -q "\.dotnet/tools" "${HOME}/.zshrc"; then
  {
    echo ""
    echo "# .NET global tools"
    echo "export PATH=\"$HOME/.dotnet/tools:$PATH\""
  } >> "${HOME}/.zshrc"
  log "Appended .NET global tools path to .zshrc"
fi

# Ensure zsh autocomplete/highlighting survives dotfiles sync
if [[ -f "${HOME}/.zshrc" ]] && ! grep -q "zsh-autosuggestions.zsh" "${HOME}/.zshrc"; then
  {
    echo ""
    echo "# zsh quality-of-life"
    echo "source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    echo "[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh"
    echo "[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh"
  } >> "${HOME}/.zshrc"
  log "Appended autosuggestions/syntax-highlighting/fzf to .zshrc"
fi

log "Done"
