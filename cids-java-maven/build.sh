#!/bin/bash

# RELEASE BUILD ----------------------------------------------------------------
docker build -t cismet/cids-java-maven:jdk-1.8u121-1.0 .

# SNAPSHOT BUILD ---------------------------------------------------------------
#docker build -t cismet/cids-java-maven:latest-snapshot -t cismet/cids-java-maven:jdk-1.8u121-1.0-SNAPSHOT .
