#!/usr/bin/make -f
css_files := $(shell find lagunita scpd suclass cme -type f -name '*.css')
sass_files := $(shell find lagunita scpd suclass cme -type f -name '*.scss')
sdk_root := ../sdk

.PHONY: help
help:  ## This.
	@perl -ne 'print if /^[a-zA-Z_-]+:.*## .*$$/' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: clean
clean:  ## Remove build artifacts
	rm -rf node_modules/

.PHONY: csslint $(css_files)
csslint: requirements $(css_files)  ## Lint CSS files
$(css_files):
	node_modules/csslint/dist/cli.js $(@)

.PHONY: sasslint $(sass_files)
sasslint: requirements $(sass_files)  ## Lint SASS files
$(sass_files):
	node_modules/sass-lint/bin/sass-lint.js --syntax scss --verbose $(@)

.PHONY: requirements
requirements:  # Install required packages
	npm install

.PHONY: test
test: sasslint csslint  ## Run all quality checks and unit tests
