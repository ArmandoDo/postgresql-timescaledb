#!/bin/bash

## This script install the dockerize version of Postgresql in your
## local environment. Run the build script before start the installation
##
## Usage:
## ./install-postgresql.sh
# set -ex
## Container registry
export REGISTRY_NAME="development"
export APP_NAME="postgresql"
export APP_TAG="15.2"

## Get the OS
OS_TYPE=$(uname)

## Verify if the port is available
check_port_availability() {
    if sudo lsof -i :${POSTGRESQL_CONTAINER_PORT} >/dev/null; then
        echo "Error: The port ${POSTGRESQL_CONTAINER_PORT} is busy."
        echo "Please set up a new port using the env variable POSTGRESQL_CONTAINER_PORT"
        exit 1
    fi
}

## Install docker image on linux
install_postgresql() {
    set_up_env_variable_file
    prepare_data_dir
    stop_container
    check_port_availability
    # Run container from docker compose
    ${DOCKER_COMPOSE_COMMAND} --file ${DOCKER_COMPOSE_FILE} up --detach ${APP_NAME}
}

### Create data folder
prepare_data_dir() {
    local dir="/var/lib/postgresql/data"

    if [ ! -d "${dir}" ]; then
        echo "Preparing data ${dir} directory in host..."
        group=$(id -gn)
        sudo mkdir -p ${dir}
        sudo chown ${USER}:${group} ${dir}
        sudo chmod u+rxw ${dir}
    else
        echo "The folder ${dir} exits in host..."
    fi
}

# Set up the docker compose command available on the server
set_up_docker_compose_command() {
    if command -v docker-compose &> /dev/null; then
        export DOCKER_COMPOSE_COMMAND="docker-compose"
    elif command -v docker compose &> /dev/null; then
        export DOCKER_COMPOSE_COMMAND="docker compose"
    else
        echo "Docker Compose is not installed or started in your system.
        Please install the service."
        echo "Exiting..."

        exit 1
    fi
}

# Set up the environment variable file .env
set_up_env_variable_file() {
    if ! source .env; then
        echo "Missing .env file with the environment variables. Please create the .env file"
        exit 1
    fi
    # Set the container port for Postgresql (Default: 5432)
    export POSTGRESQL_CONTAINER_PORT=${POSTGRESQL_CONTAINER_PORT:-5432}
}

## Stop docker container
stop_container() {
    ${DOCKER_COMPOSE_COMMAND} --file ${DOCKER_COMPOSE_FILE} stop ${ELASTICSEARCH_APP_NAME}
    ${DOCKER_COMPOSE_COMMAND} --file ${DOCKER_COMPOSE_FILE} rm --force ${ELASTICSEARCH_APP_NAME}
}

# Verify if the Docker engine is installed on the system
verify_docker_engine() {
    # Verify if service is installed
    if ! command -v docker &> /dev/null; then
        echo "Docker Engine is not installed in your system. Please install the service..."
        echo "Exiting..."
        exit 1
    fi

    # Verify if service is running
    if ! docker info &> /dev/null; then
        echo "Docker engine is installed, but not started. Please launch the service..."
        echo "Exiting..."
        exit 1
    fi
}

## Main function
main() {
    echo "${OS_TYPE} detected. Starting the installation..."
    # Verify the OS
    case "${OS_TYPE}" in
        "Darwin")
            export DOCKER_COMPOSE_FILE="docker-compose.darwin.yml"
            verify_docker_engine
            set_up_docker_compose_command
            install_postgresql
            ;;
        "Linux")
            export DOCKER_COMPOSE_FILE="docker-compose.ubuntu.yml"
            verify_docker_engine
            set_up_docker_compose_command
            install_postgresql
            ;;
        *)
            echo "System isn't supported by this script: ${OS_TYPE}"
            echo "Please contact to the support team."
            exit 1
            ;;
    esac

    echo "${APP_NAME} docker image deployed on host..."
}

main