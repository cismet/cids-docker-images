#!/bin/bash

docker build --no-cache -t cismet/cids-integration-base:latest cids-integration-base
docker build --no-cache -t cismet/cids-java-maven:latest cids-java-maven
docker build --no-cache -t cismet/cids-server:latest cids-server
docker build --no-cache -t cismet/cids-server-rest-legacy:latest cids-server-rest-legacy
