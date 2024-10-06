VERSION := $(shell yq e '.version' config.yaml)
NAME := $(shell yq e '.name' config.yaml)
DESCRIPTION := $(shell yq e '.description' config.yaml)
REPOSITORY := $(shell yq e '.url' config.yaml)

# Get current date in ISO 8601 format
BUILD_DATE := $(shell date -u +'%Y-%m-%dT%H:%M:%SZ')

# Get current git commit hash
BUILD_REF := $(shell git rev-parse --short HEAD)

# Default target
.PHONY: all
all: build

# Echo config values
.PHONY: echo-config
echo-config:
	@echo "Version: $(VERSION)"
	@echo "Name: $(NAME)"
	@echo "Description: $(DESCRIPTION)"
	@echo "Repository: $(REPOSITORY)"
	@echo "Build Date: $(BUILD_DATE)"
	@echo "Build Ref: $(BUILD_REF)"
	@echo "Build Arch: $(shell uname -m)"

# Build target
.PHONY: build
build:
	docker build \
		--build-arg BUILD_ARCH=$(shell uname -m) \
		--build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg BUILD_DESCRIPTION="$(DESCRIPTION)" \
		--build-arg BUILD_NAME="$(NAME)" \
		--build-arg BUILD_REF=$(BUILD_REF) \
		--build-arg BUILD_REPOSITORY=$(REPOSITORY) \
		--build-arg BUILD_VERSION=$(VERSION) \
		-t devireg2mqtt:latest \
		.

# Run target
.PHONY: run
run: build
	docker run -it --rm \
		-v $(CURDIR)/options.json:/data/options.json \
		devireg2mqtt:latest

# Clean target (optional, for removing built images)
.PHONY: clean
clean:
	docker rmi devireg2mqtt:latest
