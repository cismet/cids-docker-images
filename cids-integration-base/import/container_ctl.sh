#!/bin/bash

function finish {
    ${CIDS_INTEGRATION_BASE_DIR}/cids_ctl.sh stop
}

trap finish HUP INT QUIT TERM

${CIDS_INTEGRATION_BASE_DIR}/cids_ctl.sh start $1

echo -e "\n\033[1m[hit enter key to exit] or run 'docker stop <container>'\n"
read

# stop service and clean up here
finish
echo -e "\e[32mINFO\e[39m: exited $0"