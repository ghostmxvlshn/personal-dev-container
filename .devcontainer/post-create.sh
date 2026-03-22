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

echo "post-create complete ✅"
