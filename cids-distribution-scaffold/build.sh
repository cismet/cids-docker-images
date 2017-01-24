#!/bin/bash

# RELEASE BUILD ----------------------------------------------------------------
# docker build -t cismet/cids-distribution-scaffold:latest -t cismet/cids-distribution-scaffold:4.0 .

# SNAPSHOT BUILD ---------------------------------------------------------------
docker build -t cismet/cids-distribution-scaffold:latest-snapshot -t cismet/cids-distribution-scaffold:4.1-SNAPSHOT .
