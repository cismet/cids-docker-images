#!/bin/bash

set -e

# keystore deleted in image after build!
if [[ -f ${CIDS_DISTRIBUTION_DIR}/.private/keystore && ${CIDS_DISTRIBUTION_DIR}/.private/keystore.pwd ]]; then
    echo -e "\e[32mINFO\e[39m: Signing all JR Files \e[1m${CIDS_LIB_DIR}\e[0m"
    find -L ${CIDS_LIB_DIR}/m2 -name *.jar -exec sh -c "zip -d {} META-INF/\*.SF META-INF/\*.RSA META-INF/\*.DSA" ";"
    find -L ${CIDS_LIB_DIR} -name *.jar -exec sh -c "echo {} && jarsigner -keystore ${CIDS_DISTRIBUTION_DIR}/.private/keystore -storepass `cat ${CIDS_DISTRIBUTION_DIR}/.private/keystore.pwd` {} cismet " ";"
else
    echo -e "\e[31mERROR\e[39m: Could not sign all JAR files in \e[1m${CIDS_LIB_DIR}\e[0m, keystore not available"
    # hard fail
    exit 1
fi