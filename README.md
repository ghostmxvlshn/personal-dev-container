# Personal Dev Container Setup

Portable personal development environment with .NET 10, Zsh, tmux, and practical CLI tooling.

## Included

- Base image: `mcr.microsoft.com/dotnet/sdk:10.0-preview`
- Shell/tools: `zsh`, `tmux`, `git` (latest), `curl`, `jq`, `ripgrep` (latest), `fd`, `fzf` (latest), `zoxide`, `neovim` (latest)
- CLI/runtime: `nodejs`, `npm`, `pnpm`, `gh`, `opencode`, `codex`, `copilot` (global)
- TypeScript baseline: `typescript`, `tsx`, `@types/node`, `eslint`, `prettier` (global)
- Non-root user: `dev`
- VS Code Dev Containers support

## Files

- `.devcontainer/Dockerfile`
- `.devcontainer/devcontainer.json`
- `.devcontainer/post-create.sh`

## Quick Start (VS Code)

1. Push this folder to a repo (or copy it into an existing repo).
2. Open repo in VS Code.
3. Run: **Dev Containers: Reopen in Container**.
4. (Optional) Set local env vars before open:

```bash
export GIT_USER_NAME="Maksym Voloshyn"
export GIT_USER_EMAIL="you@example.com"
```

## Quick Start (CLI Docker)

Build:

```bash
docker build -t personal-dev-env -f .devcontainer/Dockerfile .
```

Run:

```bash
docker run --name personal-dev \
  -it --rm \
  -v "$(pwd)":/workspace \
  -w /workspace \
  personal-dev-env zsh
```

## Quick Start (Docker Compose)

Set optional Git identity env vars:

```bash
export GIT_USER_NAME="Maksym Voloshyn"
export GIT_USER_EMAIL="you@example.com"
```

Build + start shell:

```bash
docker compose run --rm dev
```

Or run in background:

```bash
docker compose up -d
```

Enter running container:

```bash
docker compose exec dev zsh
```

Stop + remove runtime resources:

```bash
docker compose down
```

Remove also the persistent home volume:

```bash
docker compose down -v
```

## Makefile shortcuts

```bash
make doctor  # verify docker/compose + optional env vars
make build   # docker compose build
make up      # docker compose up -d
make shell   # docker compose exec dev zsh
make run     # docker compose run --rm dev
make down    # docker compose down
make clean   # docker compose down -v
make status  # docker compose ps
make logs    # docker compose logs -f --tail=100
```

## Verify

Inside container:

```bash
dotnet --info
zsh --version
tmux -V
git --version
rg --version
fzf --version
zoxide --version
fd --version
nvim --version | head -n 1
gh --version
opencode --version
codex --version
copilot --version
pnpm --version
tsc --version
tsx --version
eslint --version
prettier --version
git config --global --list
```

## CI build check

- GitHub Actions workflow: `.github/workflows/docker-weekly-build.yml`
- Runs weekly (Monday) + manual trigger via **Run workflow**
- Purpose: fail fast if latest upstream tool downloads break

## Dotfiles auto-sync (tmux + shell)

By default, container startup will clone/pull and apply dotfiles from:

- `https://github.com/mxvoloshin/dotfiles`

Applied files:

- `.tmux.conf` → `~/.tmux.conf`
- `.zshrc` → `~/.zshrc`
- `.ashrc` → `~/.ashrc` (if present in repo)

Behavior:

- On first create: clone + apply
- On every container start: pull latest + re-apply symlinks

Override repo URL:

```bash
export DOTFILES_REPO="https://github.com/<you>/<dotfiles>.git"
```

## Optional: oh-my-zsh

Run this inside the container if you want it:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
```

---

You can clone this repo on any machine and keep a consistent personal setup.
