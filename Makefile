root_path:=$(abspath $(dir $(lastword $(MAKEFILE_LIST)))/)
branch_name=$(shell  git symbolic-ref -q --short HEAD | sed -e "s|^heads/||")

ifneq ($(VERBOSE),)
	verbosity=-$(VERBOSE)
endif

ifneq ($(AWS_REGION),)
	REGION=$(AWS_REGION)
else ifeq ($(REGION),)
  REGION=us-east-1
endif

ifneq ($(TAG),)
	tags=--tags="$(TAG)"
endif

quiet=-qq
ifneq ($(QUIET),)
	quiet=
endif

info=
ifneq ($(INFO),)
	info=-I
endif

DEFAULT_GOAL := help

##@ [Targets]
help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

guard-%:
	@if [ "${${*}}" = "" ]; then \
		echo "Variable $* not set"; \
		exit 1; \
	fi

deploy: guard-ENV guard-REGION guard-PLAY guard-PREFIX  ## Deploy, make deploy ENV=<env> PLAY=<setup|infra> REGION=<region|[us-east-1]> [ EVARS='<key=value> ...' ] [ TAG=<tag> ]
	@cd $(root_path)/ansible && \
  ANSIBLE_PYTHON_INTERPRETER=$(shell which python) ansible-playbook $(verbosity) \
		--inventory=inventory/ \
		--extra-vars="aws_profile=$(ENV) aws_region=$(REGION) branch_name=$(branch_name) prefix=$(PREFIX) $(EVARS)" \
		$(PLAY).yml $(tags)

lambda: guard-ENV guard-REGION guard-PREFIX  ## lambda, make lambda ENV=<env> REGION=<region|[us-east-1]> [ EVARS='<key=value> ...' ] [ TAG=<tag> ]
	@cd $(root_path)/ansible && \
  ANSIBLE_PYTHON_INTERPRETER=$(shell which python) ansible-playbook $(verbosity) \
		--inventory=inventory/ \
		--extra-vars="aws_profile=$(ENV) aws_region=$(REGION) branch_name=$(branch_name) prefix=$(PREFIX) $(EVARS)" \
		playbooks/50_lambda.yml $(tags)

lint: lint-ansible lint-cfn  ## Lint all projects

lint-ansible:  ## Lint Ansible project, make lint-ansible [ QUIET=1 ]
	@cd $(root_path)/ansible && \
		ansible-lint --strict -x formatting,metadata $(quiet)

lint-cfn:  ## Lint CloudFormation project, make lint-cfn [ INFO=1 ]
	@cfn-lint cloudformation/*.aws.yml $(info)

destroy: guard-ENV guard-REGION  ## Destory resources, make destroy ENV=<env> REGION=<region|[us-east-1]>
	@cd $(root_path)/ansible && \
  ANSIBLE_PYTHON_INTERPRETER=$(shell which python) ansible-playbook $(verbosity) \
		--inventory=inventory/ \
		--extra-vars="aws_profile=$(ENV) aws_region=$(REGION) branch_name=$(branch_name) $(EVARS)" \
		playbooks/XX_destroy.yml $(tags)

template: guard-ENV guard-REGION guard-PREFIX ## Template files, make template ENV=<env> REGION=<region|[us-east-1]>
	@cd $(root_path)/ansible && \
		ANSIBLE_PYTHON_INTERPRETER=$(shell which python) ansible-playbook $(verbosity) \
    --inventory=inventory/ \
    --extra-vars="aws_profile=$(ENV) aws_region=$(REGION) branch_name=$(branch_name) prefix=$(PREFIX) $(EVARS)" \
    playbooks/XX_template.yml $(tags)
