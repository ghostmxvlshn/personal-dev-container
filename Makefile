.PHONY: doctor build up shell run down clean logs status

doctor:
	@echo "Checking Docker..." && docker --version
	@echo "Checking Docker Compose..." && docker compose version
	@echo "Checking env vars..."
	@if [ -n "$$GIT_USER_NAME" ]; then echo "  GIT_USER_NAME=✅"; else echo "  GIT_USER_NAME=⚠️ (optional, not set)"; fi
	@if [ -n "$$GIT_USER_EMAIL" ]; then echo "  GIT_USER_EMAIL=✅"; else echo "  GIT_USER_EMAIL=⚠️ (optional, not set)"; fi
	@echo "Tip: after build, verify toolchain in container: git/rg/fzf/nvim/opencode/codex/copilot"

build:
	docker compose build

up:
	docker compose up -d

shell:
	docker compose exec dev zsh

run:
	docker compose run --rm dev

down:
	docker compose down

clean:
	docker compose down -v

logs:
	docker compose logs -f --tail=100

status:
	docker compose ps
