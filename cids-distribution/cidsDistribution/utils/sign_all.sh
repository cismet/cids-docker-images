#!/bin/bash

################################################################################
# BUILD-script for cids Legacy- and AutoDistributions
# Signs all JARs in the provided lib dir. Checks for existing signatures and 
# updates JAR manifests
################################################################################

# hard fail on error
set -e

if [[ -z $1 ]] ; then
    SIGNED_LIB_DIR=${MAVEN_LIB_DIR}
else
    SIGNED_LIB_DIR=$1
fi

umask 0000

# sign only files that have been modified after last call to sign_all!
if [[ ! -f ${SIGNED_LIB_DIR}/.signed ]]; then
    touch -t 197001010000.00 ${SIGNED_LIB_DIR}/.signed 
fi

# keystore deleted in image after build!
if [[ -f ${CIDS_DISTRIBUTION_DIR}/.private/keystore && ${CIDS_DISTRIBUTION_DIR}/.private/keystore.pwd ]]; then
    last_modified=$(stat -c %y "${SIGNED_LIB_DIR}/.signed")
    echo -e "\e[32mINFO\e[39m: Checking signatures of all JAR Files in \e[1m${SIGNED_LIB_DIR}\e[0m that have been modified since $last_modified"
    find -L ${SIGNED_LIB_DIR} -name *.jar -type f -newermm ${SIGNED_LIB_DIR}/.signed
    find -L ${SIGNED_LIB_DIR} -name *.jar -type f -newermm ${SIGNED_LIB_DIR}/.signed -exec ${CIDS_DISTRIBUTION_DIR}/utils/sign.sh ${CIDS_DISTRIBUTION_DIR}/.private/keystore `cat ${CIDS_DISTRIBUTION_DIR}/.private/keystore.pwd` {} \;
    touch ${SIGNED_LIB_DIR}/.signed
else
    echo -e "\e[31mERROR\e[39m: Could not check signatures of all JAR files in \e[1m${SIGNED_LIB_DIR}\e[0m, keystore not available"
    # hard fail
    exit 1
fi