#!/bin/sh

export APP_NAME="akyuu"
export APP_VSN=$(grep 'version:' mix.exs | cut -d '"' -f2)
export BUILD=$(git rev-parse --short HEAD)

echo "Building ${APP_NAME}:${APP_VSN}-${BUILD}"

docker build --build-arg APP_NAME=${APP_NAME} \
    --build-arg APP_VSN=${APP_VSN} \
    -t ${APP_NAME}:${APP_VSN}-${BUILD} \
    -t ${APP_NAME}:latest .
