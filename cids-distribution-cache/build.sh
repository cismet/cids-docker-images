#!/bin/bash


# RELEASE BUILD ----------------------------------------------------------------
docker build -t cismet/cids-distribution-cache:latest -t cismet/cids-distribution-cache:5.0 .

# SNAPSHOT BUILD ---------------------------------------------------------------
#docker build -t cismet/cids-distribution-cache:latest-snapshot -t cismet/cids-distribution-cache:5.1-SNAPSHOT .