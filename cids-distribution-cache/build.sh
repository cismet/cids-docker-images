#!/bin/bash


# RELEASE BUILD ----------------------------------------------------------------
docker build -t cismet/cids-distribution-cache:latest -t cismet/cids-distribution-cache:4.0 .

# SNAPSHOT BUILD ---------------------------------------------------------------
# docker build -t cismet/cids-distribution-cache:latest -t cismet/cids-distribution-cache:4.1-SNAPSHOT .