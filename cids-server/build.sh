#!/bin/bash

# RELEASE BUILD ----------------------------------------------------------------
docker build -t cismet/cids-server:latest -t cismet/cids-server:5.0 .

# SNAPSHOT BUILD ---------------------------------------------------------------
#docker build -t cismet/cids-server:latest-snapshot -t cismet/cids-server:5.0-SNAPSHOT .
