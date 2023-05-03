#!/usr/bin/env bash

export JAVA_HOME=/opt/java/openjdk

./usr/local/bin/docker-entrypoint.sh postgres &
./app.jar