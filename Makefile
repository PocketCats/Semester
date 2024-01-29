BUILD_PATH=build
DOCKER_BASE=$(BUILD_PATH)/docker-compose.yml
DOCKER_PROD=$(BUILD_PATH)/docker-compose.prod.yml
DOCKER_DEV=$(BUILD_PATH)/docker-compose.dev.yml

init-env:
    ifeq ($(wildcard $(BUILD_PATH)/.env),)
    	$(shell cp $(BUILD_PATH)/.env.example $(BUILD_PATH)/.env)
    endif

dev-build: init-env $(DOCKER_BASE) $(DOCKER_DEV)
	docker compose \
    	-f $(DOCKER_BASE) \
    	-f $(DOCKER_DEV) build --pull

dev-run: $(DOCKER_BASE) $(DOCKER_DEV)
	docker compose \
		-f $(DOCKER_BASE) \
		-f $(DOCKER_DEV) up -d

prod-build: $(DOCKER_BASE) $(DOCKER_PROD)
	docker compose \
		-f $(DOCKER_BASE) \
		-f $(DOCKER_PROD) build --pull

prod-run: $(DOCKER_BASE) $(DOCKER_PROD)
	docker compose \
    	-f $(DOCKER_BASE) \
    	-f $(DOCKER_PROD) up -d