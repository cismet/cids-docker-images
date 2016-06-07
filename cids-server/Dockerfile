FROM cismet/cids-java-maven

MAINTAINER Jean-Michel Ruiz <jean.ruiz@cismet.de>

ENV PGPASSWORD postgres
ENV CIDS_SERVER_IMPORT_DIR ${IMPORT_DIR}/cids-server
ENV CIDS_SERVER_DIR ${DATA_DIR}/cids-server
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