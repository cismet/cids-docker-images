#!/bin/bash

echo '###### CHECKING CIDS INTEGRATION BASE CONTAINER ######'
if test -z "${CIDS_INTEGRATION_BASE_PORT_5432_TCP_ADDR}" -o -z "${CIDS_INTEGRATION_BASE_PORT_5432_TCP_PORT}"; then
    echo "You must link this container with a CIDS_INTEGRATION_BASE container first"
    exit 1
fi
echo '###### BUILD CIDS-SERVER DISTRIBUTION ######'
mkdir -p ${CIDS_SERVER_DIR}
cp ${CIDS_SERVER_IMPORT_DIR}/settings.xml ${DATA_DIR}/
sed -i -- "s#__MAVEN_LIB_DIR__#${MAVEN_LIB_DIR:-/data/lib/m2/}#g" ${DATA_DIR}/settings.xml
cp ${CIDS_SERVER_IMPORT_DIR}/pom.xml ${CIDS_SERVER_DIR}/
cd ${CIDS_SERVER_DIR}/
sed -i -- "s#__CIDS_ACCOUNT_EXTENSION__#${CIDS_ACCOUNT_EXTENSION:-CidsReference}#g" pom.xml
sed -i -- "s#__MAVEN_LIB_DIR__#${MAVEN_LIB_DIR:-/data/lib/m2/}#g" pom.xml
sed -i -- "s#__DATA_DIR__#${DATA_DIR:-/data/}#g" pom.xml
mvn -Djavax.net.ssl.trustStore=${DATA_DIR}/truststore.ks -Djavax.net.ssl.trustStorePassword=changeit -Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true -s ${DATA_DIR}/settings.xml -Dcids.generate-lib.checkSignature=false -Dcids.generate-lib.sign=false $* clean package ${UPDATE_SNAPSHOTS}
echo '###### CHECKING CONNECTION TO CIDS INTEGRATION BASE ######'
is_ready() {
    eval "psql -h $CIDS_INTEGRATION_BASE_PORT_5432_TCP_ADDR -U postgres -c \"DROP TABLE IF EXISTS isready; CREATE TABLE isready (); COPY isready FROM '/tmp/isready.csv' DELIMITER ';' CSV HEADER\""
}
i=0
while ! is_ready;
do
    i=`expr $i + 1`
    if [ $i -ge 10 ]; then
        echo "$(date) - cids integration base container still not ready, giving up"
        exit 1
    fi
    echo "$(date) - waiting for cids integration base to be ready"
    sleep 6
done
echo '###### START LEGACY CIDS-SERVER ######'
echo 'connecting to cids Integration Base at '${CIDS_INTEGRATION_BASE_PORT_5432_TCP_ADDR:-localhost}':'${CIDS_INTEGRATION_BASE_PORT_5432_TCP_PORT:-5432}
cp ${CIDS_SERVER_IMPORT_DIR}/runtime.properties ${CIDS_SERVER_DIR}/
sed -i -- "s/__DB_HOST__/${CIDS_INTEGRATION_BASE_PORT_5432_TCP_ADDR:-localhost}/g" ${CIDS_SERVER_DIR}/runtime.properties
sed -i -- "s/__DB_PORT__/${CIDS_INTEGRATION_BASE_PORT_5432_TCP_PORT:-5432}/g" ${CIDS_SERVER_DIR}/runtime.properties
cp ${CIDS_SERVER_IMPORT_DIR}/log4j.properties ${CIDS_SERVER_DIR}/
sed -i -- "s/__LOG4J_HOST__/${LOG4J_HOST:-localhost}/g" ${CIDS_SERVER_DIR}/log4j.properties
sed -i -- "s/__LOG4J_PORT__/${LOG4J_PORT:-4445}/g" ${CIDS_SERVER_DIR}/log4j.properties
/usr/bin/java -server -Xms64m -Xmx800m -Djava.security.policy=${DATA_DIR}/policy.file -Dlog4j.configuration=file:${CIDS_SERVER_DIR}/log4j.properties -jar ${LIB_DIR}/starter${CIDS_ACCOUNT_EXTENSION}/cids-server-2.0-SNAPSHOT-starter.jar ${CIDS_SERVER_DIR}/runtime.properties