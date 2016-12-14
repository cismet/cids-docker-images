#!/bin/bash

set -e

# sign only files that have been modified after last call to sign_all!
if [[ ! -f ${MAVEN_LIB_DIR}/.signed ]]; then
    touch -t 197001010000.00 ${MAVEN_LIB_DIR}/.signed 
fi

# keystore deleted in image after build!
if [[ -f ${CIDS_DISTRIBUTION_DIR}/.private/keystore && ${CIDS_DISTRIBUTION_DIR}/.private/keystore.pwd ]]; then
    last_modified=$(stat -c %y "${MAVEN_LIB_DIR}/.signed")
    echo -e "\e[32mINFO\e[39m: Checking signatures of all JAR Files in \e[1m${MAVEN_LIB_DIR}\e[0m that have been modified since $last_modified"
    find -L ${MAVEN_LIB_DIR} -name *.jar -type f -newermm ${MAVEN_LIB_DIR}/.signed
    # don't sign maven plugins (excluded via path, list is incomplete!)
    find -L ${MAVEN_LIB_DIR} -name *.jar -type f -newermm ${MAVEN_LIB_DIR}/.signed -exec ${CIDS_DISTRIBUTION_DIR}/utils/sign.sh ${CIDS_DISTRIBUTION_DIR}/.private/keystore `cat ${CIDS_DISTRIBUTION_DIR}/.private/keystore.pwd` {} \;
    touch ${MAVEN_LIB_DIR}/.signed
else
    echo -e "\e[31mERROR\e[39m: Could not check signatures of all JAR files in \e[1m${MAVEN_LIB_DIR}\e[0m, keystore not available"
    # hard fail
    exit 1
fi