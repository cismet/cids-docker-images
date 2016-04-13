FROM cismet/cids-java-maven

MAINTAINER Pascal Dihé <pascal.dihe@cismet.de>

ENV DATA_DIR /data
ENV IMPORT_DIR /import
ENV CIDS_SERVER_REST_LEGACY_IMPORT_DIR ${IMPORT_DIR}/cids-server-rest-legacy
ENV LIB_DIR ${DATA_DIR}/lib
ENV MAVEN_LIB_DIR ${LIB_DIR}/m2
ENV CIDS_SERVER_REST_LEGACY_DIR ${DATA_DIR}/cids-server-rest-legacy

# change this when creating container: set same CIDS_ACCOUNT_EXTENSION as in pom.xml
ENV CIDS_ACCOUNT_EXTENSION CidsReference

RUN mkdir -p ${CIDS_SERVER_REST_LEGACY_IMPORT_DIR}
RUN mkdir -p ${MAVEN_LIB_DIR}
RUN mkdir -p ${CIDS_SERVER_REST_LEGACY_DIR}

COPY policy.file ${CIDS_SERVER_REST_LEGACY_DIR}/

WORKDIR ${DATA_DIR}/

#VOLUME ${DATA_DIR}

EXPOSE 8890

CMD \
  echo '###### BUILD CIDS-SERVER-REST-LEGACY DISTRIBUTION ######' && \
  cp ${CIDS_SERVER_REST_LEGACY_IMPORT_DIR}/settings.xml ${CIDS_SERVER_REST_LEGACY_DIR}/ && \
  cp ${CIDS_SERVER_REST_LEGACY_IMPORT_DIR}/pom.xml ${CIDS_SERVER_REST_LEGACY_DIR}/ && \
  cd ${CIDS_SERVER_REST_LEGACY_DIR} && \
  mvn -Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true -s ${CIDS_SERVER_REST_LEGACY_DIR}/settings.xml -Dcids.generate-lib.checkSignature=false -Dcids.generate-lib.sign=false $* clean package -U && \
  echo '###### START CIDS-SERVER-REST-LEGACY SERVER ######' && \
  echo 'connecting to cids-server at '${CIDS_SERVER_PORT_9986_TCP_ADDR:-localhost}':'${CIDS_SERVER_PORT_9986_TCP_PORT:-9986} && \
  cp ${CIDS_SERVER_REST_LEGACY_IMPORT_DIR}/runtime.properties ${CIDS_SERVER_REST_LEGACY_DIR}/ && \
  sed -i -- "s/__CIDS_SERVER_HOST__/${CIDS_SERVER_PORT_9986_TCP_ADDR:-localhost}/g" ${CIDS_SERVER_REST_LEGACY_DIR}/runtime.properties && \
  sed -i -- "s/__CIDS_SERVER_PORT__/${CIDS_SERVER_PORT_9986_TCP_PORT:-9986}/g" ${CIDS_SERVER_REST_LEGACY_DIR}/runtime.properties && \
  cp ${CIDS_SERVER_REST_LEGACY_IMPORT_DIR}/log4j.properties ${CIDS_SERVER_REST_LEGACY_DIR}/ && \
  sed -i -- "s/__LOG4J_HOST__/${LOG4J_HOST:-localhost}/g" ${CIDS_SERVER_DIR}/log4j.properties && \
  sed -i -- "s/__LOG4J_PORT__/${LOG4J_PORT:-4445}/g" ${CIDS_SERVER_DIR}/log4j.properties && \
  /usr/bin/java -server -Xms64m -Xmx800m -Djava.security.policy=policy.file -Dlog4j.configuration=log4j.properties -jar ${LIB_DIR}/starter${CIDS_ACCOUNT_EXTENSION}/cids-server-rest-legacy-1.0-SNAPSHOT-starter.jar @runtime.properties