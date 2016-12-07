#!/bin/bash

#docker rmi -f $(docker images -q pdihe/cismet/cids-distribution-cache:latest)

# this is not needed since the image is organisation name is included in the image name (seems to be sufficient for authorisation)
#docker tag $(docker images -q cismet/cids-distribution-cache:latest) pdihe/cismet/cids-distribution-cache:latest
#docker images

docker login
docker push pdihe/cismet/cids-distribution-cache:latest