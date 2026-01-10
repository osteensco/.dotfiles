
.DEFAULT_GOAL := help

# ---- Dockerfiles ----
FEDORA_DOCKERFILE := docker/fedora.Dockerfile
BREW_DOCKERFILE   := docker/brew.Dockerfile
DEBIAN_DOCKERFILE := docker/debian.Dockerfile

# ---- Images ----
FEDORA_IMAGE := dotfiles:fedora
BREW_IMAGE   := dotfiles:brew
DEBIAN_IMAGE := dotfiles:debian

# ---- Compose services ----
FEDORA_SERVICE := dotfiles_test_fedora
BREW_SERVICE   := dotfiles_test_brew
DEBIAN_SERVICE := dotfiles_test_debian

# ---- Builds ----
fedora-build: ## Build Fedora image
	docker build -f $(FEDORA_DOCKERFILE) -t $(FEDORA_IMAGE) .

brew-build: ## Build Homebrew (macOS) image
	docker build -f $(BREW_DOCKERFILE) -t $(BREW_IMAGE) .

debian-build: ## Build Debian image
	docker build -f $(DEBIAN_DOCKERFILE) -t $(DEBIAN_IMAGE) .

# ---- Runners ----
fedora-run: ## Run Fedora test container
	docker-compose run --rm $(FEDORA_SERVICE)

brew-run: ## Run Homebrew test container
	docker-compose run --rm $(BREW_SERVICE)

debian-run: ## Run Debian test container
	docker-compose run --rm $(DEBIAN_SERVICE)



fedora: fedora-build fedora-run ## Build + run Fedora
brew: brew-build brew-run ## Build + run Homebrew
debian: debian-build debian-run ## Build + run Debian

help: ## Show this help
	@echo "Available commands:"
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z0-9_-]+:.*##/ { printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
