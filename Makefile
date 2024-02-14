BUILD_ROOT=.deploy
BUILD_PATH=$(BUILD_ROOT)/build
DOCKER_BASE=$(BUILD_PATH)/docker-compose.yml
DOCKER_PROD=$(BUILD_PATH)/docker-compose.prod.yml
DOCKER_DEV=$(BUILD_PATH)/docker-compose.dev.yml

DB_CONTAINER=semester-db
MIGRATIONS_PATH=$(BUILD_ROOT)/migrations

build-prod: \
	stop \
	prune \
	init-env $(DOCKER_BASE) $(DOCKER_DEV) \
	build-prod-image

build-dev: \
	stop \
	prune \
	init-env $(DOCKER_BASE) $(DOCKER_DEV) \
	build-dev-image \
	run-dev \
	up-migrations \
	stop

init-env:
    ifeq ($(wildcard $(BUILD_PATH)/.env),)
    	$(shell cp $(BUILD_PATH)/.env.example $(BUILD_PATH)/.env)
    endif

build-dev-image: init-env $(DOCKER_BASE) $(DOCKER_DEV)
	docker compose \
    	-f $(DOCKER_BASE) \
    	-f $(DOCKER_DEV) build --pull

run-dev: $(DOCKER_BASE) $(DOCKER_DEV)
	docker compose \
		-f $(DOCKER_BASE) \
		-f $(DOCKER_DEV) up -d

build-prod-image: $(DOCKER_BASE) $(DOCKER_PROD)
	docker compose \
		-f $(DOCKER_BASE) \
		-f $(DOCKER_PROD) build --pull

run-prod: $(DOCKER_BASE) $(DOCKER_PROD)
	docker compose \
    	-f $(DOCKER_BASE) \
    	-f $(DOCKER_PROD) up -d

stop:
	docker compose -f $(DOCKER_BASE) stop

prune:
	docker compose \
	 -f $(DOCKER_BASE) \
     -f $(DOCKER_PROD) down --remove-orphans

read_params:
	$(eval DB_PORT := $(shell grep '^DB_PORT=' "$(BUILD_PATH)/.env" | cut -d '=' -f2)) \
	$(eval DB_DRIVER := $(shell grep '^DB_DRIVER=' "$(BUILD_PATH)/.env" | cut -d '=' -f2)) \
    $(eval DB_USER := $(shell grep '^DB_USER=' "$(BUILD_PATH)/.env" | cut -d '=' -f2)) \
    $(eval DB_PASSWORD := $(shell grep '^DB_PASSWORD=' "$(BUILD_PATH)/.env" | cut -d '=' -f2)) \
    $(eval DB_HOST := $(shell grep '^DB_HOST=' "$(BUILD_PATH)/.env" | cut -d '=' -f2)) \
    $(eval DB_NAME := $(shell grep '^DB_NAME=' "$(BUILD_PATH)/.env" | cut -d '=' -f2)) \

.PHONY: up-migrations
up-migrations: read_params
	./scripts/migrate.sh \
        --db_driver=$(DB_DRIVER) \
        --db_user=$(DB_USER) \
        --db_password=$(DB_PASSWORD) \
        --db_host=$(DB_HOST) \
        --db_port=$(DB_PORT) \
        --db_name=$(DB_NAME) \
        --build_path=$(BUILD_PATH) \
        --container_name=$(DB_CONTAINER) \
        --migrations_folder=$(MIGRATIONS_PATH) \
        --command=up

.PHONY: down-migrations
down-migrations: read_params
	./scripts/migrate.sh \
      	--db_driver=$(DB_DRIVER) \
      	--db_user=$(DB_USER) \
          --db_password=$(DB_PASSWORD) \
          --db_host=$(DB_HOST) \
          --db_port=$(DB_PORT) \
          --db_name=$(DB_NAME) \
          --build_path=$(BUILD_PATH) \
          --container_name=$(DB_CONTAINER) \
          --migrations_folder=$(MIGRATIONS_PATH) \
          --command="down -all"