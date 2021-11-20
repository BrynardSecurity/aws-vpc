.PHONY: terraform

include .env

terraform_init:
	@docker run --rm -it \
		-v ${CURDIR}:/go/src/github.com/hashicorp/terraform \
		-w /go/src/github.com/hashicorp/terraform \
		hashicorp/terraform:latest \
		init

