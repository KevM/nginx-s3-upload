REGISTRYHOST = docker.tabbedout.com
USERNAME ?= tabbedout
NAME = black-tongue-s3
IMAGE = $(REGISTRYHOST)/$(USERNAME)/$(NAME)

DEBUG = -d -p 80:80
PROD = --detach
DOCKER_ARGS = $(DEBUG)

help:
	@echo "Help"
	@echo "-----------------------------------------------------------"
	@echo "build     Build the latest version"
	@echo "push      Push the latest version to $(REGISTRYHOST)"
	@echo "bash      Shell into the image for debugging"
	@echo "run       Run a local container that connects to QA"


build:
	#cd black-tongue && git fetch && git checkout origin/develop
	docker build -t $(IMAGE) .

push:
	docker push $(IMAGE)

bash: clean
	docker run --rm  --name $(NAME) -it $(IMAGE) /bin/bash

# http://black-tongue.local/api/v1/_status/
run: clean
	docker run $(DOCKER_ARGS) --name $(NAME) --env-file .env \
	  $(IMAGE)
	docker logs $(NAME)

clean:
	@docker rm -f $(NAME) &>/dev/null || true
