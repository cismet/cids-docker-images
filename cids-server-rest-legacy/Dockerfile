FROM cismet/cids-java-maven:jdk-1.8u112-1.1

MAINTAINER Pascal Dihé <pascal.dihe@cismet.de>

LABEL de.cismet.cids.server.rest.legacy.name="cids server rest legacy runtime image" \
      de.cismet.cids.server.rest.legacy.version="4.1-SNAPSHOT" \
      de.cismet.cids.server.rest.legacy.tag.docker="4.1-SNAPSHOT" \
      de.cismet.cids.server.rest.legacy.tag.git="cidsServerRestLegacy-4.1-SNAPSHOT" \
      de.cismet.cids.server.rest.legacy.descripton="Generic cids-server-rest-legacy Runtime Image for local testing and integration tests" 

ENV CIDS_SERVER_REST_LEGACY_IMPORT_DIR ${IMPORT_DIR}/cids-server-rest-legacy
ENV CIDS_SERVER_REST_LEGACY_DIR ${DATA_DIR}/cids-server-rest-legacy
ENV CIDS_SERVER_REST_LEGACY_STARTER cids-server-rest-legacy-4.0-starter.jar

RUN mkdir -p ${CIDS_SERVER_REST_LEGACY_IMPORT_DIR}
RUN mkdir -p ${CIDS_SERVER_REST_LEGACY_DIR}

WORKDIR ${DATA_DIR}/

# VOLUME ${DATA_DIR}

EXPOSE 8890

# use volume from CIDS_SERVER: need to create CIDS_SERVER_REST_LEGACY_DIR in RUN!

# copy startup script
COPY startup.sh /tmp/
RUN chmod +x /tmp/startup.sh

# start
CMD /tmp/startup.sh