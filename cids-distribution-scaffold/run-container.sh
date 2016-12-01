#!/bin/bash

docker stop cids-distribution-scaffold

docker rm -v -f cids-distribution-scaffold
docker run -it --name cids-distribution-scaffold \
    -v ~/git_work/docker-images/cids-distribution-scaffold/cidsDistribution/client/:/cidsDistribution/client/ \
    -v ~/git_work/docker-images/cids-distribution-scaffold/cidsDistribution/server/:/cidsDistribution/server/ \
    -v ~/git_work/docker-images/cids-distribution-scaffold/cidsDistribution/lib/local/:/cidsDistribution/lib/local/ \
    cismet/cids-distribution-scaffold:latest

#    -v ~/git_work/docker-images/cids-distribution/cidsDistribution/utils/:/cidsDistribution/utils/ \
#    -v ~/git_work/docker-images/cids-distribution/cidsDistribution/cids_ctl.sh:/cidsDistribution/cids_ctl.sh \