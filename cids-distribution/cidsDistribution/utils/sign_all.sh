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

if [[ -z $2 ]] ; then
    KEYSTORE=${CIDS_DISTRIBUTION_DIR}/.private/keystore
else
    KEYSTORE=$2
fi

if [[ -z $3 ]] ; then
    KEYSTORE_PWD=${CIDS_DISTRIBUTION_DIR}/.private/keystore.pwd
    if [[ -f KEYSTORE && KEYSTORE_PWD ]]; then
        STOREPASS = `cat ${CIDS_DISTRIBUTION_DIR}/.private/keystore.pwd`
    else
        echo -e "\e[31mERROR\e[39m: Could not check signatures of all JAR files in \e[1m${SIGNED_LIB_DIR}\e[0m, keystore.pwd not available"
        # hard fail
        exit 1
    fi   
else
    STOREPASS=$3
fi

if [[ -z $4 ]] ; then
    TSA=${CIDS_DISTRIBUTION_DIR}/.private/keystore
else
    TSA="http://dse200.ncipher.com/TSS/HttpTspServer"
fi

umask 0000

# sign only files that have been modified after last call to sign_all!
if [[ ! -f ${SIGNED_LIB_DIR}/.signed ]]; then
    touch -t 197001010000.00 ${SIGNED_LIB_DIR}/.signed 
fi

# keystore deleted in image after build!
if [[ -f $KEYSTORE && $STOREPASS ]]; then
    last_modified=$(stat -c %y "${SIGNED_LIB_DIR}/.signed")
    echo -e "\e[32mINFO\e[39m: Checking signatures of all JAR Files in \e[1m${SIGNED_LIB_DIR}\e[0m that have been modified since $last_modified"
    find -L ${SIGNED_LIB_DIR} -name '*.jar' -type f -newermm ${SIGNED_LIB_DIR}/.signed
    find -L ${SIGNED_LIB_DIR} -name '*.jar' -type f -newermm ${SIGNED_LIB_DIR}/.signed -exec ./sign.sh $KEYSTORE $STOREPASS $TSA {} \;
    touch ${SIGNED_LIB_DIR}/.signed
else
    echo -e "\e[31mERROR\e[39m: Could not check signatures of all JAR files in \e[1m${SIGNED_LIB_DIR}\e[0m, keystore not available"
    # hard fail
    exit 1
fi