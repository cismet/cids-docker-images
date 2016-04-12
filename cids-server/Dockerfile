FROM cismet/cids-java-maven

MAINTAINER Jean-Michel Ruiz <jean.ruiz@cismet.de>

ENV POSTGRES_PASSWORD postgres
ENV DATA_DIR /data
ENV IMPORT_DIR /import
ENV LIB_DIR ${DATA_DIR}/lib
ENV MAVEN_LIB_DIR ${LIB_DIR}/m2
ENV CIDS_SERVER_DIR ${DATA_DIR}/cids-server

ENV starterCidsRef

RUN mkdir -p ${DATA_DIR}/
RUN mkdir -p ${LIB_DIR}/
RUN mkdir -p ${CIDS_SERVER_DIR}/
RUN mkdir -p ${IMPORT_DIR}/

WORKDIR ${DATA_DIR}/

VOLUME ${DATA_DIR}

EXPOSE 9986

CMD \
  echo '###### BUILD DISTRIBUTION ######' && \
  cp ${IMPORT_DIR}/settings.xml ${DATA_DIR}/ && \
  cp ${IMPORT_DIR}/pom.xml ${CIDS_SERVER_DIR}/ && \
  cd ${CIDS_SERVER_DIR} && \
  mvn -Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true -s ${DATA_DIR}/settings.xml -Dcids.generate-lib.checkSignature=false -Dcids.generate-lib.sign=false $* clean package -U && \
  echo '###### START LEGACY SERVER ######' && \
  cp ${IMPORT_DIR}/runtime.properties ${CIDS_SERVER_DIR}/ && \
  sed -i -- "s/__DB_HOST__/${DB_PORT_5432_TCP_ADDR}/g" ${CIDS_SERVER_DIR}/runtime.properties && \
  sed -i -- "s/__DB_PORT__/${DB_PORT_5432_TCP_PORT}/g" ${CIDS_SERVER_DIR}/runtime.properties && \
  /usr/bin/java -Xms64m -Xmx800m -Djava.security.policy=policy.file -jar ${LIB_DIR}/starterCidsServer/cids-server-2.0-SNAPSHOT-starter.jar ${CIDS_SERVER_DIR}/runtime.properties