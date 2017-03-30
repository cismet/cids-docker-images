#!/bin/bash

# copy JNLP & _security.jar generated when image was built to the lib/starter dir on the host-mounted volume!
#
# This behaviour is currently inconsitent with cids auto distribution (cids-maven-plugin v5.0). 
# See https://github.com/cismet/cids-docker-images/issues/15
#
# WARNING: Does not work if the auto distribution uses multiple account extensions 
# (e.g. https://github.com/cismet/cids-distribution-wuppertal/)
# See https://github.com/cismet/cids-docker-images/issues/16
umask 0000

if [[ -d ${CIDS_CLIENT_DIR}/${CIDS_ACCOUNT_EXTENSION,,} ]]; then
    echo -e "\e[32mINFO\e[39m: Copy client starter files from ${CIDS_CLIENT_DIR}/${CIDS_ACCOUNT_EXTENSION,,}/"
    find ${CIDS_CLIENT_DIR}/${CIDS_ACCOUNT_EXTENSION,,}/ -name "*.jnlp" -type f -exec cp {} ${CIDS_LIB_DIR}/starter${CIDS_ACCOUNT_EXTENSION}/ \;
    find ${CIDS_CLIENT_DIR}/${CIDS_ACCOUNT_EXTENSION,,}/ -name "*_security.jar" -type f -exec cp {} ${CIDS_LIB_DIR}/starter${CIDS_ACCOUNT_EXTENSION}/ \;
elif [[ -d ${CIDS_CLIENT_DIR}/${CIDS_ACCOUNT_EXTENSION} ]]; then
    echo -e "\e[32mINFO\e[39m: Copy client starter files from ${CIDS_CLIENT_DIR}/${CIDS_ACCOUNT_EXTENSION}/"
    find ${CIDS_CLIENT_DIR}/${CIDS_ACCOUNT_EXTENSION}/ -name "*.jnlp" -type f -exec cp {} ${CIDS_LIB_DIR}/starter${CIDS_ACCOUNT_EXTENSION}/ \;
    find ${CIDS_CLIENT_DIR}/${CIDS_ACCOUNT_EXTENSION}/ -name "*_security.jar" -type f -exec cp {} ${CIDS_LIB_DIR}/starter${CIDS_ACCOUNT_EXTENSION}/ \;
else
    echo -e "\e[32mINFO\e[39m: Copy client starter files from ${CIDS_CLIENT_DIR}/"
    find ${CIDS_CLIENT_DIR}/ -name "*.jnlp" -type f -exec cp {} ${CIDS_LIB_DIR}/starter${CIDS_ACCOUNT_EXTENSION}/ \;
    find ${CIDS_CLIENT_DIR}/ -name "*_security.jar" -type f -exec cp {} ${CIDS_LIB_DIR}/starter${CIDS_ACCOUNT_EXTENSION}/ \;
fi