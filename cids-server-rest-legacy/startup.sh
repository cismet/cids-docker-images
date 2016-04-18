#!/bin/bash

echo '###### CHECKING CIDS SERVER CONTAINER ######'
if test -z "${CIDS_SERVER_PORT_9986_TCP_ADDR}" -o -z "${CIDS_SERVER_PORT_9986_TCP_PORT}"; then
    echo "You must link this container with a CIDS-SERVER container first"
    exit 1
fi
echo '###### BUILD CIDS-SERVER-REST-LEGACY DISTRIBUTION ######'
mkdir -p ${CIDS_SERVER_REST_LEGACY_DIR}
cp ${CIDS_SERVER_REST_LEGACY_IMPORT_DIR}/pom.xml ${CIDS_SERVER_REST_LEGACY_DIR}/
cd ${CIDS_SERVER_REST_LEGACY_DIR}/
mvn -Djavax.net.ssl.trustStore=${DATA_DIR}/truststore.ks -Djavax.net.ssl.trustStorePassword=changeit -Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true -s ${DATA_DIR}/settings.xml -Dcids.generate-lib.checkSignature=false -Dcids.generate-lib.sign=false $* clean package -U
echo '###### START CIDS-SERVER-REST-LEGACY SERVER ######'
echo 'connecting to cids-server at '${CIDS_SERVER_PORT_9986_TCP_ADDR:-localhost}':'${CIDS_SERVER_PORT_9986_TCP_PORT:-9986}
cp ${CIDS_SERVER_REST_LEGACY_IMPORT_DIR}/runtime.properties ${CIDS_SERVER_REST_LEGACY_DIR}/
sed -i -- "s/__CIDS_SERVER_HOST__/${CIDS_SERVER_PORT_9986_TCP_ADDR:-localhost}/g" ${CIDS_SERVER_REST_LEGACY_DIR}/runtime.properties
sed -i -- "s/__CIDS_SERVER_PORT__/${CIDS_SERVER_PORT_9986_TCP_PORT:-9986}/g" ${CIDS_SERVER_REST_LEGACY_DIR}/runtime.properties
cp ${CIDS_SERVER_REST_LEGACY_IMPORT_DIR}/log4j.properties ${CIDS_SERVER_REST_LEGACY_DIR}/
sed -i -- "s/__LOG4J_HOST__/${LOG4J_HOST:-localhost}/g" ${CIDS_SERVER_REST_LEGACY_DIR}/log4j.properties
sed -i -- "s/__LOG4J_PORT__/${LOG4J_PORT:-4445}/g" ${CIDS_SERVER_REST_LEGACY_DIR}/log4j.properties
/usr/bin/java -server -Xms64m -Xmx800m -Djava.security.policy=${DATA_DIR}/policy.file -Dlog4j.configuration=log4j.properties -jar ${LIB_DIR}/starter${CIDS_ACCOUNT_EXTENSION}/cids-server-rest-legacy-1.0-SNAPSHOT-starter.jar @runtime.properties