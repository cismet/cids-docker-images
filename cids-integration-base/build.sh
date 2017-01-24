#!/bin/bash

# RELEASE BUILD ----------------------------------------------------------------
docker build -t cismet/cids-integration-base:latest -t cismet/cids-integration-base:postgres-9.6.1-2.0 .

SNAPSHOT BUILD ---------------------------------------------------------------
docker build -t cismet/cids-integration-base:latest-snapshot -t cismet/cids-integration-base:postgres-9.6.1-2.0-SNAPSHOT .