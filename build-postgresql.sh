#!/bin/bash

## This script builds the dockerize version of Postgresql in your
## local environment. Modify the config files if it's necessary
## 
## Usage:
## ./build-postgresql.sh

## Container registry
REGISTRY_NAME="development"
APP_NAME="postgresql"
APP_TAG="15.2"

## Get the OS
OS_TYPE=$(uname)

## Build docker image
containerize_linux() {
    echo "Building ${APP_NAME} image in ${REGISTRY_NAME}/${APP_NAME}:${APP_TAG}"

    docker build --rm --no-cache --progress=plain \
        -t ${REGISTRY_NAME}/${APP_NAME}:${APP_TAG} \
        -f ./postgresql/Dockerfile ./postgresql
    
    echo "Docker image building has completed successfully for ${APP_NAME}"
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
            containerize_linux
            ;;
        *)
            echo "System isn't supported by this script: ${OS_TYPE}"
            echo "Please contact to the support team."
            exit 1
            ;;
    esac
}

main