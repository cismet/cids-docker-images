FROM cismet/cids-java-maven:jdk-1.8u112-1.1

MAINTAINER Jean-Michel Ruiz <jean.ruiz@cismet.de>

LABEL de.cismet.cids.server.name="server runtime image" \
      de.cismet.cids.server.version="4.0" \
      de.cismet.cids.server.tag.docker="4.0" \
      de.cismet.cids.server.tag.git="cidsServer-4.0" \
      de.cismet.cids.server.descripton="Generic cids-server Runtime Image for local testing and integration tests" 

ENV PGPASSWORD postgres
ENV CIDS_SERVER_IMPORT_DIR ${IMPORT_DIR}/cids-server
ENV CIDS_SERVER_DIR ${DATA_DIR}/cids-server
ENV CIDS_SERVER_STARTER cids-server-4.0-starter.jar

RUN mkdir -p ${CIDS_SERVER_IMPORT_DIR}
RUN mkdir -p ${CIDS_SERVER_DIR}

WORKDIR ${DATA_DIR}/

#VOLUME ${DATA_DIR}

EXPOSE 9986

COPY icons ${CIDS_SERVER_DIR}/icons

# copy startup script
COPY startup.sh /tmp/
RUN chmod +x /tmp/startup.sh

# start
CMD /tmp/startup.sh  