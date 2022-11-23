SHELL := $(shell which bash)

PWD := $(shell pwd)
USER := $(shell id -u)

docs:
	@docker run --rm --volume "$(PWD):/terraform-docs" -u $(USER) quay.io/terraform-docs/terraform-docs:0.16.0 markdown /terraform-docs --output-file README.md
