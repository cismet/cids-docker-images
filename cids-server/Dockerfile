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

# copy startup script
COPY startup.sh /tmp/
RUN chmod +x /tmp/startup.sh

# start
CMD /tmp/startup.sh  