#!/bin/sh

include $(MAKEFILE_UTILS_DIR)/makefile-utils.mk

SHELL := sh

DOCKER_COMPOSE := docker-compose

# Run tests used to build Docker image (Docker Hub automated tests)
# Used locally only. Docker Hub called "sut" automatically.
.PHONY: docker-hub-sut
docker-hub-sut:
	@echo ""
	@echo "Test Docker image build (Docker Hub sut):"
	@echo ""
	@$(DOCKER_COMPOSE) --file docker-compose.test.yml build \
		--progress tty --quiet base-image sut && \
	$(DOCKER_COMPOSE) --file docker-compose.test.yml up sut && \
	$(DOCKER_COMPOSE) --file docker-compose.test.yml down \
		--volumes --remove-orphans --rmi all
	@echo ""
	@echo $(call print_success, "✔ Test Docker image build (Docker Hub sut): OK")
