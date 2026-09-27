.DEFAULT_GOAL := help

SWIFT := swift
CONFIG := {"lineLength":120,"tabWidth":4,"indentation":{"tabs":1}}
SOURCES := ./Tanuki

.PHONY: help fmt lint check

help:
	@printf 'make fmt    format sources in place\n'
	@printf 'make lint   report style issues\n'
	@printf 'make check  format, then lint\n'

fmt:
	$(SWIFT) format -p -r -i --configuration '$(CONFIG)' $(SOURCES)

lint:
	@findings="$$($(SWIFT) format lint -p -r --configuration '$(CONFIG)' $(SOURCES) 2>&1)"; \
	if [ -n "$$findings" ]; then \
		printf '%s\n' "$$findings" >&2; \
		printf '\nlint failed (%s findings) - run make fmt\n' "$$(printf '%s\n' "$$findings" | wc -l | tr -d ' ')" >&2; \
		exit 1; \
	fi
	@printf 'lint passed\n'

check: fmt lint
