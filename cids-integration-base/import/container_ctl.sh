#!/bin/bash

function finish {
    ${CIDS_INTEGRATION_BASE_DIR}/cids_ctl.sh stop
}

trap finish HUP INT QUIT TERM

echo -e "\e[32mINFO\e[39m: Starting container (arguments: $1, $2)"
${CIDS_INTEGRATION_BASE_DIR}/cids_ctl.sh $1 $2

echo -e "\n\e[32mhit [CTRL+C] to exit or run 'docker stop <container>'\e[39m:\n"
sleep infinity

# stop service and clean up here
finish
echo -e "\e[32mINFO\e[39m: exited $0"
