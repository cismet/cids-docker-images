FROM cismet/cids-java-maven

MAINTAINER Jean-Michel Ruiz <jean.ruiz@cismet.de>

ENV PGPASSWORD postgres
ENV DATA_DIR /data
ENV IMPORT_DIR /import
ENV CIDS_SERVER_IMPORT_DIR ${IMPORT_DIR}/cids-server
ENV LIB_DIR ${DATA_DIR}/lib
ENV MAVEN_LIB_DIR ${LIB_DIR}/m2
ENV CIDS_SERVER_DIR ${DATA_DIR}/cids-server

# change this when creating container: set same CIDS_ACCOUNT_EXTENSION as in pom.xml
ENV CIDS_ACCOUNT_EXTENSION CidsReference

RUN mkdir -p ${CIDS_SERVER_IMPORT_DIR}
RUN mkdir -p ${MAVEN_LIB_DIR}
RUN mkdir -p ${CIDS_SERVER_DIR}

WORKDIR ${DATA_DIR}/

#VOLUME ${DATA_DIR}

EXPOSE 9986

CMD \
  echo '###### CHECKING CIDS INTEGRATION BASE CONTAINER ######' && \
  if test -z "${CIDS_INTEGRATION_BASE_PORT_5432_TCP_ADDR}" -o -z "${CIDS_INTEGRATION_BASE_PORT_5432_TCP_PORT}"; then \
      echo "You must link this container with a CIDS_INTEGRATION_BASE container first" && \
      exit 1 && \
  fi \
  echo '###### BUILD CIDS-SERVER DISTRIBUTION ######' && \
  cp ${CIDS_SERVER_IMPORT_DIR}/settings.xml ${DATA_DIR}/ && \
  cp ${CIDS_SERVER_IMPORT_DIR}/pom.xml ${CIDS_SERVER_DIR}/ && \
  cd ${CIDS_SERVER_DIR} && \
  mvn -Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true -s ${DATA_DIR}/settings.xml -Dcids.generate-lib.checkSignature=false -Dcids.generate-lib.sign=false $* clean package -U && \
  echo '###### CHECKING CONNECTION TO CIDS INTEGRATION BASE ######' && \
  is_ready() { \
    eval eval "psql -h $CIDS_INTEGRATION_BASE_PORT_5432_TCP_ADDR -U postgres -c \"CREATE TABLE isready (); COPY isready FROM '/tmp/isready.csv' DELIMITER ';' CSV HEADER\"" \
  } && \
  i=0 && \
  while ! is_ready; do \
      i=`expr $i + 1` && \
      if [ $i -ge 5 ]; then \
          echo "$(date) - cids integration base container still not ready, giving up" && \
          exit 1 && \
      fi \
      echo "$(date) - waiting for cids integration base to be ready" && \
      sleep 5000 && \
  done && \
  echo '###### START LEGACY CIDS-SERVER ######' && \
  echo 'connecting to cids Integration Base at '${CIDS_INTEGRATION_BASE_PORT_5432_TCP_ADDR:-localhost}':'${CIDS_INTEGRATION_BASE_PORT_5432_TCP_PORT:-5432} && \
  cp ${CIDS_SERVER_IMPORT_DIR}/runtime.properties ${CIDS_SERVER_DIR}/ && \
  sed -i -- "s/__DB_HOST__/${CIDS_INTEGRATION_BASE_PORT_5432_TCP_ADDR:-localhost}/g" ${CIDS_SERVER_DIR}/runtime.properties && \
  sed -i -- "s/__DB_PORT__/${CIDS_INTEGRATION_BASE_PORT_5432_TCP_PORT:-5432}/g" ${CIDS_SERVER_DIR}/runtime.properties && \
  cp ${CIDS_SERVER_IMPORT_DIR}/log4j.properties ${CIDS_SERVER_DIR}/ && \
  sed -i -- "s/__LOG4J_HOST__/${LOG4J_HOST:-localhost}/g" ${CIDS_SERVER_DIR}/log4j.properties && \
  sed -i -- "s/__LOG4J_PORT__/${LOG4J_PORT:-4445}/g" ${CIDS_SERVER_DIR}/log4j.properties && \
  /usr/bin/java -server -Xms64m -Xmx800m -Djava.security.policy=${DATA_DIR}/policy.file -Dlog4j.configuration=log4j.properties -jar ${LIB_DIR}/starter${CIDS_ACCOUNT_EXTENSION}/cids-server-2.0-SNAPSHOT-starter.jar ${CIDS_SERVER_DIR}/runtime.properties