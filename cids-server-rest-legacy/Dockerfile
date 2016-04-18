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

WORKDIR ${DATA_DIR}/

VOLUME ${DATA_DIR}

EXPOSE 8890

# use volume from CIDS_SERVER: need to create CIDS_SERVER_REST_LEGACY_DIR in RUN!

# copy startup script
COPY startup.sh /tmp/
RUN chmod +x /tmp/startup.sh

# start
CMD /tmp/startup.sh