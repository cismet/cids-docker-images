#!/bin/bash

#docker rmi -f $(docker images -q pdihe/cismet/cids-distribution-cache:latest)

# this is not needed since the image is organisation name is included in the image name (seems to be sufficient for authorisation)
#docker tag $(docker images -q cismet/cids-distribution-cache:latest) pdihe/cismet/cids-distribution-cache:latest
#docker images

docker login

# PUSH RELEASE BUILD -----------------------------------------------------------
#docker push cismet/cids-distribution-cache:latest
#docker push cismet/cids-distribution-cache:4.0

# PUSH SNAPSHOT BUILD ----------------------------------------------------------
docker push cismet/cids-distribution-cache:latest-snapshot
docker push cismet/cids-distribution-cache:4.1-SNAPSHOT