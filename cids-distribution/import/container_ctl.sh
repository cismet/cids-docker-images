#!/bin/bash

function finish {
    echo -e "\e[32mINFO\e[39m: stopping cids services"
    ${CIDS_DISTRIBUTION_DIR}/cids_ctl.sh stop
    
    echo -e "\e[32mINFO\e[39m: stopping nginx"
    service nginx stop
}

function is_ready {
    eval "psql -h $CIDS_INTEGRATION_BASE_PORT_5432_TCP_ADDR -U postgres -c \"DROP TABLE IF EXISTS isready; CREATE TABLE isready (); COPY isready FROM '/tmp/isready.csv' DELIMITER ';' CSV HEADER\""
}

# USE the trap if you need to also do manual cleanup after the service is stopped,
#     or need to start multiple services in the one container
trap finish HUP INT QUIT TERM

echo -e "\e[32mINFO\e[39m: ###### CHECKING CIDS INTEGRATION BASE CONTAINER ######"
if test -z "${CIDS_INTEGRATION_BASE_PORT_5432_TCP_ADDR}" -o -z "${CIDS_INTEGRATION_BASE_PORT_5432_TCP_PORT}"; then
    echo -e "\e[33mWARN\e[39m: Container not linked with PostgreSQL container cids-integration-base"
else
    echo -e "\e[32mINFO\e[39m: container linked with PostgreSQL container cids-integration-base"
    i=0
    while ! is_ready;
    do 
        i=`expr $i + 1`
        if [ $i -ge 10 ]; then
            echo -e "\e[31mERROR\e[39m: $(date) - cids integration base PostgreSQL (${CIDS_INTEGRATION_BASE_PORT_5432_TCP_ADDR}:${CIDS_INTEGRATION_BASE_PORT_5432_TCP_PORT}) service still not ready, giving up"
            exit 1
        fi
        echo -e "\e[33mWARN\e[39m: $(date) - waiting for cids integration base PostgreSQL service (${CIDS_INTEGRATION_BASE_PORT_5432_TCP_ADDR}:${CIDS_INTEGRATION_BASE_PORT_5432_TCP_PORT}) to be ready"
        sleep 6
    done
fi

echo -e "\e[32mINFO\e[39m: ###### UPDATING SERVER CONFIGURATION ######"
${CIDS_DISTRIBUTION_DIR}/utils/update_configuration.sh

echo -e "\e[32mINFO\e[39m: ###### UPDATING CLIENT CONFIGURATION ######"
# copy JNLP genenrated when image was built to the client dir on the host-mounted volume
umask 0000
find ${CIDS_LIB_DIR}/starter${CIDS_ACCOUNT_EXTENSION}/ -name "*.jnlp" -type f -exec cp {} ${CIDS_CLIENT_DIR}/${CIDS_ACCOUNT_EXTENSION,,}/ \;

echo -e "\e[32mINFO\e[39m: ###### STARTING SERVICES ######"
# start service in background here
echo -e "\e[32mINFO\e[39m: starting cids services"
${CIDS_DISTRIBUTION_DIR}/cids_ctl.sh start

echo -e "\e[32mINFO\e[39m: starting nginx"
sed -i -- "s#__CIDS_DISTRIBUTION_DIR__#${CIDS_DISTRIBUTION_DIR:-/cidsDistribution}#g" /etc/nginx/sites-available/default
service nginx start

echo -e "\n\e[32mhit [CTRL+C] to exit or run 'docker stop <container>'\e[39m:\n"
sleep infinity

# stop service and clean up here
finish
echo -e "\e[32mINFO\e[39m: exited $0"