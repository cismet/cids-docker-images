#!/bin/bash

if [[ -z $1 ]] ; then
    echo "Usage: $0 {JNLP FILE}"
    exit 1
fi

JNLP_FILE=$1
JNLP_BASE=$(basename "$JNLP_FILE" -starter.jnlp) 

sed -i -- "s/local${CIDS_ACCOUNT_EXTENSION}\/security-jar-template.jar/classpath${CIDS_ACCOUNT_EXTENSION}\/$JNLP_BASE-security.jar/g" $JNLP_FILE

rm -rf JNLP-INF 2>> /dev/null
mkdir -p JNLP-INF
cp $JNLP_FILE JNLP-INF/APPLICATION.JNLP

jar -cfv $JNLP_BASE-security.jar JNLP-INF

mv $JNLP_BASE-security.jar ${CIDS_LIB_DIR}/classpath${CIDS_ACCOUNT_EXTENSION}/
cp $JNLP_FILE ${CIDS_LIB_DIR}/starter${CIDS_ACCOUNT_EXTENSION}/ 2>> /dev/null

rm -rf JNLP-INF 2>> /dev/null