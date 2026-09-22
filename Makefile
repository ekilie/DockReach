IMAGE?=egekocabas/remote-docker
TAG?=0.1.0

BUILDER=buildx-multi-arch

INFO_COLOR = \033[0;36m
NO_COLOR   = \033[m

build-extension: ## Build service image to be deployed as a desktop extension
	docker build --tag=$(IMAGE):$(TAG) .

build-extension-no-cache: ## Build service image to be deployed as a desktop extension without cache
	docker build --no-cache --tag=$(IMAGE):$(TAG) .

uninstall-extension: ## Uninstall the extension
	docker extension uninstall $(IMAGE):$(TAG)

install-extension: build-extension ## Install the extension
	docker extension install $(IMAGE):$(TAG) -f

update-extension: build-extension ## Update the extension
	docker extension update $(IMAGE):$(TAG) -f

run-client: ## Run the client
	npm --prefix ui install && npm --prefix ui run dev

set-extension-source: ## Set Docker extension dev source
	docker extension dev ui-source egekocabas/remote-docker:latest http://localhost:3000

debug-ui: ## Debug the UI
	docker extension dev debug egekocabas/remote-docker:latest

validate-extension: ## Validate the extension
	docker extension validate $(IMAGE):$(TAG)

prepare-buildx: ## Create buildx builder for multi-arch build, if not exists
	docker buildx inspect $(BUILDER) || docker buildx create --name=$(BUILDER) --driver=docker-container --driver-opt=network=host

push-extension: prepare-buildx ## Build & Upload extension image to hub. Do not push if tag already exists: make push-extension tag=0.1
	docker pull $(IMAGE):$(TAG) && echo "Failure: Tag already exists" || docker buildx build --push --builder=$(BUILDER) --platform=linux/amd64,linux/arm64 --build-arg TAG=$(TAG) --tag=$(IMAGE):$(TAG) .

push-extension-force-no-cache: prepare-buildx ## Build & Upload extension image to hub. Force push if tag already exists.
	docker buildx build --no-cache --push --builder=$(BUILDER) --platform=linux/amd64,linux/arm64 --build-arg TAG=$(TAG) --tag=$(IMAGE):$(TAG) .

help: ## Show this help
	@echo Please specify a build target. The choices are:
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "$(INFO_COLOR)%-30s$(NO_COLOR) %s\n", $$1, $$2}'

.PHONY: help
