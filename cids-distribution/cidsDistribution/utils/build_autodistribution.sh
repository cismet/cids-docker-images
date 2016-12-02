#!/bin/bash
set -e

cd ${CIDS_GENERATOR_DIR}/
if [[ -f ${CIDS_GENERATOR_DIR}/settings.xml]]; then
    if [[ -f ${CIDS_DISTRIBUTION_DIR}/.private/server.pwd ]]; then
        SERVER_USERNAME=$(cat ${CIDS_DISTRIBUTION_DIR}/.private/server.pwd | grep SERVER_USERNAME | cut -f 2 -d "=")
        SERVER_PASSWORD=$(cat ${CIDS_DISTRIBUTION_DIR}/.private/server.pwd | grep SERVER_PASSWORD | cut -f 2 -d "=")

        sed -i -- "s#__MAVEN_LIB_DIR__#${MAVEN_LIB_DIR:-/cidsDistribution/lib/m2/}#g" ${CIDS_GENERATOR_DIR}/settings.xml
        sed -i -- "s#__SERVER_USERNAME__#$SERVER_USERNAME#g" ${CIDS_GENERATOR_DIR}/settings.xml
        sed -i -- "s#__SERVER_PASSWORD__#$SERVER_PASSWORD#g" ${CIDS_GENERATOR_DIR}/settings.xml

        for GENERATOR_DIR in *; do
            if [[ -d $GENERATOR_DIR && -f $GENERATOR_DIR/pom.xml ]]; then
                echo -e "\e[32mINFO\e[39m: Building cids auto distribution \e[1m$$GENERATOR_DIR\e[0m"
                cd ${CIDS_GENERATOR_DIR}/${GENERATOR_DIR} 
                
                sed -i -- "s#__CIDS_ACCOUNT_EXTENSION__#${CIDS_ACCOUNT_EXTENSION}#g" pom.xml
                sed -i -- "s#__MAVEN_LIB_DIR__#${MAVEN_LIB_DIR:-/cidsDistribution/lib/m2/}#g" pom.xml
                sed -i -- "s#__DATA_DIR__#${DATA_DIR:-/cidsDistribution/}#g" pom.xml

                mvn -Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true -s ${CIDS_GENERATOR_DIR}/settings.xml -Dcids.generate-lib.checkSignature=false -Dcids.generate-lib.sign=false clean package ${UPDATE_SNAPSHOTS}
            else
                echo -e "\e[33mWARN\e[39m: \e[1m$GENERATOR_DIR\e[0m is no valid autodistribution generator directory (pom.xml missing)"
            fi
        done

        # brute force signing!
        ${CIDS_DISTRIBUTION_DIR}/utils/sign_all.sh

    else
        echo -e "\e[31mERROR\e[39m: Cannot build autodistributions server password file is missing"
        exit 1
    fi
else
    echo -e "\e[31mERROR\e[39m: Cannot build autodistributions, settings.xml is missing"
    exit 1
fi