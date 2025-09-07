
# Default task
.DEFAULT_GOAL := help
.PHONY: help build publish

help: ## Display this help
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}'

serve: ## Serve site
	hugo server -D --disableFastRender --buildDrafts --buildFuture --buildExpired -w

clean: ## Clean site
	rm -rf public/*
	rm -rf resources/*

check_dependencies: ## Check dependencies
	@bash bin/check_dependencies.sh

install: ## Install dependencies
	@bash bin/install.sh
