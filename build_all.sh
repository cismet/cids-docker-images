#!/bin/bash

docker build -t cismet/cids-integration-base:latest cids-integration-base
docker build -t cismet/cids-java-maven:latest cids-java-maven
docker build -t cismet/cids-server:latest cids-server
docker build -t cismet/cids-server-rest-legacy:latest cids-server-rest-legacy
