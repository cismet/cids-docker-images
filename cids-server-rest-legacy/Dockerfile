FROM cismet/cids-java-maven

MAINTAINER Pascal Dihé <pascal.dihe@cismet.de>

ENV CIDS_SERVER_REST_LEGACY_IMPORT_DIR ${IMPORT_DIR}/cids-server-rest-legacy
ENV CIDS_SERVER_REST_LEGACY_DIR ${DATA_DIR}/cids-server-rest-legacy

RUN mkdir -p ${CIDS_SERVER_REST_LEGACY_IMPORT_DIR}
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