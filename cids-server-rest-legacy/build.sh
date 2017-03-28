#!/bin/bash

# RELEASE BUILD ----------------------------------------------------------------
docker build -t cismet/cids-server-rest-legacy:latest -t cismet/cids-server-rest-legacy:5.0 .

# SNAPSHOT BUILD ---------------------------------------------------------------
#docker build -t cismet/cids-server-rest-legacy:latest-snapshot -t cismet/cids-server-rest-legacy:5.1-SNAPSHOT .
