BUILD_DIR := build
RELEASE_DIR := release
APP_NAME := hello-saltstack
GOLANG_VER := 1.10-stretch
RELEASE_FILES := build/hello-saltstack service/hello-saltstack.service service/init.sls

.PHONY: help build release clean

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Build the application and run unit tests
	if [ ! -d $(BUILD_DIR)/ ]; then mkdir -p $(BUILD_DIR)/; fi
	$ docker run --rm \
			--volume $(PWD):/usr/src/$(APP_NAME) \
			--workdir /usr/src/$(APP_NAME) \
			golang:$(GOLANG_VER) \
			/bin/bash -c \
			"go get -t -d -v ./... && \
			go test -v | tee $(BUILD_DIR)/testoutput.txt && \
			go build -v -o $(BUILD_DIR)/$(APP_NAME)"

release: build ## create a release
	if [ ! -d $(RELEASE_DIR)/ ]; then mkdir -p $(RELEASE_DIR)/; fi
	cp $(RELEASE_FILES) $(RELEASE_DIR)/

clean: ## Clean build output
	rm -rf $(BUILD_DIR)/*
	rm -rf $(RELEASE_DIR)/*
