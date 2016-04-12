FROM cismet/maven

MAINTAINER Jean-Michel Ruiz <jean.ruiz@cismet.de>

ENV DATA_DIR /data
ENV LIB_DIR /data/lib
ENV SERVER_LEGACY_DIR /data/server-legacy
ENV SERVER_REST_DIR /data/server-rest
ENV IMPORT_DIR /data/import/

ENV PGPASSWORD postgres

RUN mkdir -p ${DATA_DIR}/
RUN mkdir -p ${LIB_DIR}/
RUN mkdir -p ${SERVER_LEGACY_DIR}/
RUN mkdir -p ${SERVER_REST_DIR}/
RUN mkdir -p ${IMPORT_DIR}/

WORKDIR ${DATA_DIR}/



VOLUME ${DATA_DIR}

EXPOSE 9986

CMD \
  echo '###### BUILD DISTRIBUTION ######' && \
  cp ${IMPORT_DIR}/settings.xml ${DATA_DIR}/ && \
  cp ${IMPORT_DIR}/pom.xml ${SERVER_LEGACY_DIR}/ && \
  cd ${SERVER_LEGACY_DIR} && \
  mvn -Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true -s ${DATA_DIR}/settings.xml -Dcids.generate-lib.checkSignature=false -Dcids.generate-lib.sign=false $* clean package -U && \
  echo '###### START LEGACY SERVER ######' && \
  cp ${IMPORT_DIR}/runtime.properties ${SERVER_LEGACY_DIR}/ && \
  sed -i -- "s/__DB_HOST__/${DB_PORT_5432_TCP_ADDR}/g" ${SERVER_LEGACY_DIR}/runtime.properties && \
  sed -i -- "s/__DB_PORT__/${DB_PORT_5432_TCP_PORT}/g" ${SERVER_LEGACY_DIR}/runtime.properties && \
  /usr/bin/java -Xms64m -Xmx800m -Djava.security.policy=policy.file -jar ${LIB_DIR}/starterCidsRef/cids-server-2.0-SNAPSHOT-starter.jar ${SERVER_LEGACY_DIR}/runtime.properties
