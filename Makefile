# Tanuki development tasks.
#
# `make` (or `make help`) lists every target.

.DEFAULT_GOAL := help

CONFIG         := ./format.json
SWIFT          := swift
APPLY          := $(SWIFT) format -p -r -i --configuration $(CONFIG)
LINT           := $(SWIFT) format lint -p -r --configuration $(CONFIG)

# Hand-written sources only. apollo-gitlab-api/ is generated code: it is
# committed exactly as apollo-ios-cli emits it (never reformatted), so fmt and
# lint must not touch it — formatting it made `make fmt` rewrite the generated
# tree and `make lint` report ~1 600 findings.
TANUKI_SOURCES := tanuki-app/Package.swift tanuki-app/Sources

APOLLO_CONFIG  := ./apollo-codegen-config.json
# apollo-ios-cli ships as a prebuilt release binary, not as a package product
# (the pinned apollo-skip-fuse dependency only exposes libraries). The download
# script places it in the working directory, which is the repository root.
APOLLO_CLI     := ./apollo-ios-cli
APOLLO_INSTALL := ./download-apollo-cli.sh

.PHONY: help fmt lint check icons sbom generate-apollo fetch-schema install-apollo-cli \
        check-generated clean

# --- Development -------------------------------------------------------------

help: ## List available targets
	@printf 'Usage: make <target>\n\nTargets:\n'
	@awk 'BEGIN { FS = ":.*##" } \
		/^[a-zA-Z0-9_.-]+:.*##/ { printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2 }' \
		$(MAKEFILE_LIST)

fmt: ## Format hand-written Swift sources in place
	@$(call need,$(TANUKI_SOURCES))
	$(APPLY) $(TANUKI_SOURCES)

lint: ## Lint hand-written Swift sources without modifying them
	@$(call need,$(TANUKI_SOURCES))
	$(LINT) $(TANUKI_SOURCES)

check: fmt lint ## Format, then lint (pre-commit gate)
	@echo "all checks passed"

# --- Assets ------------------------------------------------------------------

icons: ## Regenerate the bundled Android symbol assets (network)
	$(SWIFT) scripts/gen-symbolsets.swift

# --- SBOM --------------------------------------------------------------------

# `skip meta sbom create` drives Gradle for the Android half, and the default
# Homebrew `openjdk` (27) is too new for it — Homebrew's Gradle itself targets
# openjdk@25. Honour a globally exported JAVA_HOME, else fall back to that JDK;
# override with `make sbom SBOM_JAVA_HOME=/path/to/jdk`.
SBOM_JAVA_HOME ?= $(if $(JAVA_HOME),$(JAVA_HOME),$(shell p=$$(brew --prefix openjdk@25 2>/dev/null); [ -n "$$p" ] && echo "$$p/libexec/openjdk.jdk/Contents/Home"))

sbom: ## Regenerate the bundled SPDX bill of materials (network; drives Gradle)
	@$(call need,tanuki-app)
	@jh="$(SBOM_JAVA_HOME)"; \
	if [ -n "$$jh" ] && [ ! -x "$$jh/bin/java" ]; then \
		echo "error: SBOM_JAVA_HOME='$$jh' does not look like a JDK" >&2; exit 1; \
	fi; \
	cd tanuki-app && JAVA_HOME="$$jh" skip meta sbom create \
		-d Sources/Tanuki/Resources $${jh:+--java-home "$$jh"} --project .

# --- Apollo GraphQL ----------------------------------------------------------

# Note: apollo-ios-cli v2.x uses -p/--path for the config file, not
# --configuration.
generate-apollo: fetch-schema | $(APOLLO_CLI) ## Fetch the GitLab schema and regenerate GitLabAPI
	$(APOLLO_CLI) generate --path $(APOLLO_CONFIG)

fetch-schema: | $(APOLLO_CLI) ## Refetch schema.graphqls only
	$(APOLLO_CLI) fetch-schema --path $(APOLLO_CONFIG)

install-apollo-cli: $(APOLLO_CLI) ## Download apollo-ios-cli (VERSION=x.y.z to pin)
	@$(APOLLO_CLI) --version

# Order-only prerequisite: the CLI is a tool, so its freshness never makes the
# generated output stale.
$(APOLLO_CLI):
	@echo "downloading apollo-ios-cli"
	$(APOLLO_INSTALL)

check-generated: generate-apollo ## Fail if the committed generated code is stale
	@git diff --quiet -- schema.graphqls 'apollo-gitlab-api/Sources' || { \
		echo "error: schema or generated sources are out of date"; \
		git diff --stat -- schema.graphqls 'apollo-gitlab-api/Sources'; \
		exit 1; }

# --- Housekeeping ------------------------------------------------------------

clean: ## Remove downloaded build artifacts
	rm -f $(APOLLO_CLI)
	rm -f schema.graphqls
	rm -rf apollo-gitlab-api/.build

# --- Internals ---------------------------------------------------------------

# need(list): fail with a clear message when an expected path has gone missing,
# instead of a tool silently formatting or linting nothing.
define need
for p in $(1); do \
	if [ ! -e "$$p" ]; then \
		echo "error: missing path '$$p' (renamed or moved?)" >&2; exit 1; \
	fi; \
done
endef
