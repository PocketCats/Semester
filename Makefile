BUILD_PATH=build
DOCKER_BASE=$(BUILD_PATH)/docker-compose.yml
DOCKER_PROD=$(BUILD_PATH)/docker-compose.prod.yml
DOCKER_DEV=$(BUILD_PATH)/docker-compose.dev.yml

init-env:
    ifeq ($(wildcard $(BUILD_PATH)/.env),)
    	$(shell cp $(BUILD_PATH)/.env.example $(BUILD_PATH)/.env)
    endif

build-dev: init-env $(DOCKER_BASE) $(DOCKER_DEV)
	docker compose \
    	-f $(DOCKER_BASE) \
    	-f $(DOCKER_DEV) build --pull

run-dev: $(DOCKER_BASE) $(DOCKER_DEV)
	docker compose \
		-f $(DOCKER_BASE) \
		-f $(DOCKER_DEV) up

build-prod: $(DOCKER_BASE) $(DOCKER_PROD)
	docker compose \
		-f $(DOCKER_BASE) \
		-f $(DOCKER_PROD) build --pull

run-prod: $(DOCKER_BASE) $(DOCKER_PROD)
	docker compose \
    	-f $(DOCKER_BASE) \
    	-f $(DOCKER_PROD) up -d

prune:
	docker compose \
	 -f $(DOCKER_BASE) \
     -f $(DOCKER_PROD) down --remove-orphans