#!/bin/bash

## This script install the dockerize version of Postgresql in your
## local environment. Run the build script before start the installation
##
## Usage:
## ./install-postgresql.sh
set -ex
## Container registry
export REGISTRY_NAME="development"
export APP_NAME="postgresql"
export APP_TAG="15.2"

## Get the OS
OS_TYPE=$(uname)

### Create data folder
prepare_data_dir() {
    local dir="/var/lib/postgresql/data"

    if [ ! -d "${dir}" ]; then
        echo "Preparing data ${dir} directory in host..."
        sudo mkdir -p ${dir}
        sudo chown ${USER}:${USER} ${dir}
        sudo chmod u+rxw ${dir}
    else
        echo "The folder ${dir} exits in host..."
    fi
}

## Install docker image on linux
install_on_linux() {
    source .env
    prepare_data_dir
    stop_container
    docker compose --file docker-compose.yml up --detach ${APP_NAME}

}

### Stop docker container
stop_container() {
    docker compose --file docker-compose.yml stop ${APP_NAME}
    docker compose --file docker-compose.yml rm --force ${APP_NAME}
}

## Main function
main() {
    echo "${OS_TYPE} detected. Starting the installation..."
    # Verify the OS
    case "${OS_TYPE}" in
        "Darwin")
            echo "install_darwin"
            ;;
        "Linux")
            install_on_linux
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