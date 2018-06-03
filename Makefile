BUILD_DIR 			:= build
RELEASE_DIR 		:= release
APP_NAME 				:= hello-saltstack
GOLANG_VER 			:= 1.10-stretch
RELEASE_FILES 	:= build/hello-saltstack service/hello-saltstack.service service/init.sls service/config.yaml

.PHONY: help build release deploy clean all

help: ## Well, this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Build the application and run unit tests
	if [ ! -d $(BUILD_DIR)/ ]; then mkdir -p $(BUILD_DIR)/; fi
	# Build app inside a docker container to avoid dependency to local Go environment
	$ docker run --rm \
			--volume $(PWD):/usr/src/$(APP_NAME) \
			--workdir /usr/src/$(APP_NAME) \
			golang:$(GOLANG_VER) \
			/bin/bash -c \
			"go get -t -d -v ./... && \
			go test -v | tee $(BUILD_DIR)/testoutput.txt && \
			go build -v -o $(BUILD_DIR)/$(APP_NAME)"

release: ## Create a release
	# Copy files to release dir
	cp $(RELEASE_FILES) $(RELEASE_DIR)/
	# Copy files to minion master
	for FILE in $(RELEASE_FILES) ; do \
		vagrant scp $$FILE master:/srv/salt/web ; \
	done

deploy: ## Deploy to current version
	# Apply salt state over ssh
	vagrant ssh master -c "sudo salt '*' state.apply"

clean: ## Clean build output
	rm -rf $(BUILD_DIR)/*
	rm -rf $(RELEASE_DIR)/*

all: build release deploy clean ## Do everything from build to deploy
