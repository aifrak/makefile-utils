#!/bin/sh

include $(MAKEFILE_UTILS_DIR)/makefile-utils.mk

SHELL := sh

DOCKER := docker

SHELLCHECK := koalaman/shellcheck:v0.7.1
SHELLCHECK_PATH := ./src/**.sh
SHELLCHECK_HOST_DIR := ${PWD}

SHELLSPEC := shellspec/shellspec:0.28.1
SHELLSPEC_HOST_DIR := ${PWD}

# Print list of commands
.PHONY: shell-help
shell-help:
	@echo ""
	@echo "Shell test commands:"
	@echo "  shell-test-all:          Run all unit tests and linter for shell scripts"
	@echo "  shell-linter:            Run shell linter"
	@echo "  shell-tests:             Run shell unit tests"
	@echo "  shell-tests-format:      Run check format on Shellspec files"

# Run all unit tests and linter for shell scripts
.PHONY: shell-test-all
shell-test-all: shell-linter shell-tests-format shell-tests

# Run shell linter
.PHONY: shell-linter
shell-linter:
	@echo ""
	@echo "- Check shell linter:"
	@echo ""
	@$(DOCKER) run --rm -v "${SHELLCHECK_HOST_DIR}:/mnt" ${SHELLCHECK} ${SHELLCHECK_PATH} \
		--shell=$(SHELL) --format=tty -x
	@echo ""
	@echo $(call print_success, "Shell linter: OK")

# Run shell unit tests
.PHONY: shell-tests
shell-tests:
	@echo ""
	@echo "- Check shell unit tests:"
	@echo ""
	@$(DOCKER) run -it --rm -v "${SHELLSPEC_HOST_DIR}:/src" ${SHELLSPEC} \
	--format progress --jobs 10
	@echo $(call print_success, "Shell unit tests: OK")

# Run check format on Shellspec files
.PHONY: shell-tests-format
shell-tests-format:
	@echo ""
	@echo "- Check format of shell unit tests:"
	@echo ""
	@$(DOCKER) run -it --rm -v "${SHELLSPEC_HOST_DIR}:/src" ${SHELLSPEC} \
		--syntax-check
	@echo ""
	@echo $(call print_success, "Format of shell unit tests: OK")
