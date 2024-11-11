.PHONY: help ps build build-prod start fresh fresh-prod stop restart destroy \
	cache cache-clear migrate migrate migrate-fresh tests tests-html

CONTAINER_PHP=api
CONTAINER_REDIS=redis
CONTAINER_DATABASE=database

help: ## Print help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

auth: ## Authenticate to the AWS ECR.
	aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin 287043655912.dkr.ecr.ap-northeast-2.amazonaws.com

build-push: ## Build and push the docker image to the AWS ECR.
	make build
	make push

build: ## Build the docker image.
	docker build -t laravel/base-image .

push: ## Push the docker image to the AWS ECR.
	docker tag laravel/base-image:latest 287043655912.dkr.ecr.ap-northeast-2.amazonaws.com/laravel/base-image:latest 
	docker push 287043655912.dkr.ecr.ap-northeast-2.amazonaws.com/laravel/base-image:latest
