#!/bin/bash

function finish {
    echo -e "\e[32mINFO\e[39m: stopping cids services"
    ${CIDS_DISTRIBUTION_DIR}/cids_ctl.sh stop
}


# USE the trap if you need to also do manual cleanup after the service is stopped,
#     or need to start multiple services in the one container
trap finish HUP INT QUIT TERM

# start service in background here
echo -e "\e[32mINFO\e[39m: starting cids services"
${CIDS_DISTRIBUTION_DIR}/cids_ctl.sh start
echo -e "\n\033[1m[hit enter key to exit] or run 'docker stop <container>'\n"
read

# stop service and clean up here
finish
echo -e "\e[32mINFO\e[39m: exited $0"