#!/bin/bash

log() {
  echo "[$(date +"%Y-%m-%d %T")]: $1" >> "$log_file"
}

parse_args() {
  read_input "$@"
  validate_input
}

read_input() {
      while [[ $# -gt 0 ]]; do
            case $1 in
                --db_driver=*)
                    db_driver="${1#*=}"
                    shift
                    ;;
                --db_user=*)
                    db_user="${1#*=}"
                    shift
                    ;;
                --db_password=*)
                    db_password="${1#*=}"
                    shift
                    ;;
                --db_host=*)
                    db_host="${1#*=}"
                    shift
                    ;;
                --db_port=*)
                    db_port="${1#*=}"
                    shift
                    ;;
                --db_name=*)
                    db_name="${1#*=}"
                    shift
                    ;;
                --command=*)
                    command="${1#*=}"
                    shift
                    ;;
                --build_path=*)
                    build_path="${1#*=}"
                    shift
                    ;;
                 --container_name=*)
                    container_name="${1#*=}"
                    shift
                    ;;
                 --migrations_folder=*)
                    migrations_folder="${1#*=}"
                    shift
                    ;;
                --log_file=*)
                    log_file="${1#*=}"
                    shift
                    ;;
                *)
                    echo "Invalid argument: $1"
                    exit 1
                    ;;
            esac
        done

      if [ -z "${log_file}" ]; then
          log_file="/dev/stdout"
          log "Log will be outputted to stdout"
      fi
}

validate_input() {
    required_args=("build_path" "db_driver" "db_user" "db_password" "db_host" "db_port" "db_name" "container_name" "migrations_folder")

    for arg in "${required_args[@]}"; do
        if [[ -z "${!arg}" ]]; then
              log "Missing required argument: $arg"
              exit 1
        fi
    done
}

wait_for_healthy_db() {
    retries=0
    max_retries=10

    if ! [ "$(docker inspect -f '{{.State.Running}}' "$container_name" 2>/dev/null)" == "true" ]; then
        log "Please, up your container with db before running migrations, . $container_name is not running."
        exit 1
    fi

    while [ $retries -lt $max_retries ]; do
        status=$(docker inspect --format='{{.State.Health.Status}}' "$container_name")

        if [ "$status" == "healthy" ]; then
            log: "Container $container_name is healthy. Starting migrations..."
            return 0
        fi

        log "Container $container_name is not healthy yet. Retrying in 5 seconds... (Attempt $((retries+1)))"

        retries=$((retries+1))
        sleep 5
    done

    log "Timeout: Container $container_name did not become healthy after $max_retries attempts."
    exit 1
}

build_container() {
    if [ "$(docker ps -a -q -f name=migrator)" ]; then
        docker stop migrator
        docker rm migrator
        docker build \
            --build-arg USER_UID=$(id -u) \
            --build-arg USER_GID=$(id -g) \
            -t migrator \
            -f "$build_path/migrator/Dockerfile" \
            .deploy > /dev/null

        log "building migrator container"
    fi
}

run_container() {
    docker run -d \
        --network build_default \
        --env-file "$build_path/.env" \
        --user 1000:1000 \
        --name migrator \
        -v "$(pwd)/${migrations_folder}:/bin/migrator/migrations:rw" \
        migrator > /dev/null

    log "running migrator container"
}

run_migrations() {
    # Use parsed arguments directly
    # Explode string to command and flags
    IFS=' ' read -ra cmd_args <<< "$command"

    docker exec migrator ./migrate \
      -source "file://migrations" \
      -database "$db_driver://$db_user:$db_password@$db_host:$db_port/$db_name?sslmode=disable" "${cmd_args[@]}" || true
}
stop_container() {
    docker stop migrator > /dev/null
    log "migrator container stopped"
}

run() {
    parse_args "$@"

    wait_for_healthy_db

    build_container
    run_container

    run_migrations
    stop_container
}

run "$@"