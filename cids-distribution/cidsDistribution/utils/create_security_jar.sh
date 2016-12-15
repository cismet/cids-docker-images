#!/bin/bash

if [[ -z $1 ]] ; then
    echo -e "\e[31mERROR\e[39m: Usage: $0 {JNLP FILE}"
    exit 1
elif [[ -f ${CIDS_DISTRIBUTION_DIR}/.private/keystore && ${CIDS_DISTRIBUTION_DIR}/.private/keystore.pwd ]]; then
    JNLP_FILE=$1
    JNLP_BASE=$(basename "$JNLP_FILE" -starter.jnlp) 

    umask 0000

    sed -i -- "s/local${CIDS_ACCOUNT_EXTENSION}\/security-jar-template.jar\"/classpath${CIDS_ACCOUNT_EXTENSION}\/$JNLP_BASE-security.jar\" main=\"true\"/g" $JNLP_FILE
    
    rm -rf JNLP-INF 2>> /dev/null
    rm -f MANIFEST.TXT 2>> /dev/null

    mkdir -p JNLP-INF
    cp $JNLP_FILE JNLP-INF/APPLICATION.JNLP

    printf "Permissions: all-permissions\n" > MANIFEST.TXT
    printf "Codebase: *\n" >> MANIFEST.TXT
    printf "Caller-Allowable-Codebase: *\n" >> MANIFEST.TXT
    printf "Application-Library-Allowable-Codebase: *\n" >> MANIFEST.TXT
    printf "Application-Name: cids Navigator\n" >> MANIFEST.TXT
    printf "Trusted-Only: true\n" >> MANIFEST.TXT
    printf "Sealed: true\n" >> MANIFEST.TXT
    printf "\n" >> MANIFEST.TXT

    jar -cfmv $JNLP_BASE-security.jar MANIFEST.TXT JNLP-INF
    ${CIDS_DISTRIBUTION_DIR}/utils/sign.sh ${CIDS_DISTRIBUTION_DIR}/.private/keystore `cat ${CIDS_DISTRIBUTION_DIR}/.private/keystore.pwd` $JNLP_BASE-security.jar

    mv $JNLP_BASE-security.jar ${CIDS_LIB_DIR}/classpath${CIDS_ACCOUNT_EXTENSION}/
    cp $JNLP_FILE ${CIDS_LIB_DIR}/starter${CIDS_ACCOUNT_EXTENSION}/ 2>> /dev/null

    rm -rf JNLP-INF 2>> /dev/null
    rm -f MANIFEST.TXT 2>> /dev/null
else
    echo -e "\e[31mERROR\e[39m: Could not sign all JAR file for \e[1m$1\e[0m, keystore not available"
    # hard fail
    exit 1
fi