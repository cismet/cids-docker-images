#!/bin/bash

# RELEASE BUILD ----------------------------------------------------------------
# docker build -t cismet/cids-java-maven:jdk-1.8u112-1.1 .

SNAPSHOT BUILD ---------------------------------------------------------------
# docker build -t cismet/cids-java-maven:latest-snapshot -t cismet/cids-java-maven:jdk-1.8u112-1.1-SNAPSHOT .
