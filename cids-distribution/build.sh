#!/bin/bash

# RELEASE BUILD ----------------------------------------------------------------
# docker build -t cismet/cids-distribution:latest -t cismet/cids-distribution:4.0 .

# SNAPSHOT BUILD ---------------------------------------------------------------
docker build -t cismet/cids-distribution:latest-snapshot -t cismet/cids-distribution:4.1-SNAPSHOT .