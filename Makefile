HUGO_VERSION ?= 0.166.0
PORT ?= 1313

# Use a local hugo if installed, otherwise run the official image with podman (or docker).
ifneq ($(shell command -v hugo 2>/dev/null),)
HUGO ?= hugo
HUGO_SERVE ?= $(HUGO)
SERVE_FLAGS ?=
else
ENGINE ?= $(shell command -v podman 2>/dev/null || command -v docker 2>/dev/null)
TTY := $(shell test -t 0 && echo -it)
RUN := $(ENGINE) run --rm $(TTY) -v "$(CURDIR)":/src -w /src
IMAGE := ghcr.io/gohugoio/hugo:v$(HUGO_VERSION)
HUGO ?= $(RUN) $(IMAGE)
HUGO_SERVE ?= $(RUN) -p $(PORT):$(PORT) $(IMAGE)
SERVE_FLAGS ?= --bind 0.0.0.0 --poll 700ms
endif

.DEFAULT_GOAL := help
.PHONY: help serve build clean new version

help: ## Show available targets
	@grep -E '^[a-z-]+:.*## ' $(MAKEFILE_LIST) | awk -F ':.*## ' '{printf "  %-10s %s\n", $$1, $$2}'

serve: ## Run the dev server with drafts at http://localhost:1313 (override with PORT=)
	$(HUGO_SERVE) server --buildDrafts --port $(PORT) $(SERVE_FLAGS)

build: ## Build the production site into public/
	$(HUGO) build --gc --minify

clean: ## Remove generated files
	rm -rf public resources/_gen .hugo_build.lock

new: ## Create a new post: make new SLUG=my-post-title
	@test -n "$(SLUG)" || { echo "usage: make new SLUG=my-post-title"; exit 1; }
	$(HUGO) new content blog/$(shell date +%Y/%m/%d)/$(SLUG).md

version: ## Print the Hugo version in use
	$(HUGO) version
