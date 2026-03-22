#!/usr/bin/env bash
set -euo pipefail

# Set git identity from environment (preferred)
if [[ -n "${GIT_USER_NAME:-}" ]]; then
  git config --global user.name "${GIT_USER_NAME}"
fi

if [[ -n "${GIT_USER_EMAIL:-}" ]]; then
  git config --global user.email "${GIT_USER_EMAIL}"
fi

# Optional shell niceties
if ! grep -q "alias ll='ls -la'" ~/.zshrc 2>/dev/null; then
  {
    echo ""
    echo "# Personal defaults"
    echo "alias ll='ls -la'"
    echo "alias gs='git status -sb'"
  } >> ~/.zshrc
fi

# Ensure zoxide is initialized for zsh
if ! grep -q "zoxide init zsh" ~/.zshrc 2>/dev/null; then
  {
    echo ""
    echo "# zoxide"
    echo "eval \"$(zoxide init zsh)\""
  } >> ~/.zshrc
fi

# Ensure useful zsh completion/plugins are loaded
if ! grep -q "zsh-autosuggestions.zsh" ~/.zshrc 2>/dev/null; then
  {
    echo ""
    echo "# zsh quality-of-life"
    echo "source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    echo "[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh"
    echo "[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh"
  } >> ~/.zshrc
fi

# Ensure dotnet global tools path
if ! grep -q "\.dotnet/tools" ~/.zshrc 2>/dev/null; then
  {
    echo ""
    echo "# .NET global tools"
    echo "export PATH=\"$HOME/.dotnet/tools:$PATH\""
  } >> ~/.zshrc
fi

# Install/update Aspire CLI for the dev user
if command -v aspire >/dev/null 2>&1; then
  dotnet tool update --global aspire.cli >/dev/null 2>&1 || true
else
  dotnet tool install --global aspire.cli >/dev/null 2>&1 || true
fi

echo "post-create complete ✅"
