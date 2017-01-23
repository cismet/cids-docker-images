#!/bin/bash

(cd cids-integration-base && exec build.sh)
(cd cids-integration-base && exec build.sh)
(cd cids-java-maven && exec build.sh)
(cd cids-server && exec build.sh)
(cd cids-server-rest-legacy && exec build.sh)
(cd cids-distribution && exec build.sh)
(cd cids-distribution-cache && exec build.sh)
(cd cids-distribution-scaffold && exec build.sh)
