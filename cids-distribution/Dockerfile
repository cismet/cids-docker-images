FROM cismet/cids-java-maven:latest

MAINTAINER Pascal Dihé <pascal.dihe@cismet.de>

LABEL de.cismet.cids.distribution.name="cids-distribution image" \
      de.cismet.cids.distribution.version="cidsDistribution-1.0" \
      de.cismet.cids.distribution.descripton="General abstract cids distribution Runtime Image" 

# set account extension to empty string
# ENV CIDS_ACCOUNT_EXTENSION=""
# keep DATA_DIR for backwards compatilibity with cids-server-* images
ENV CIDS_DISTRIBUTION_DIR ${DATA_DIR} 
ENV CIDS_LIB_DIR ${CIDS_DISTRIBUTION_DIR}/lib
ENV CIDS_LOCAL_DIR ${CIDS_LIB_DIR}/local${CIDS_ACCOUNT_EXTENSION}
ENV CIDS_STARTER_DIR ${CIDS_LIB_DIR}/starter${CIDS_ACCOUNT_EXTENSION}
ENV CIDS_SERVER_DIR ${CIDS_DISTRIBUTION_DIR}/server
ENV CIDS_CLIENT_DIR ${CIDS_DISTRIBUTION_DIR}/client

WORKDIR ${CIDS_DISTRIBUTION_DIR}/

# use .dockerignore to control which files go into the image and which not (faster!)
COPY cidsDistribution ${CIDS_DISTRIBUTION_DIR}/

# IMPORTANT: Define the volume in custom images not in the base image!
# VOLUME ${CIDS_DISTRIBUTION_DIR}/

RUN chmod -R +x *.sh

# add /tmp as volume since it may contain data that changes often
VOLUME /tmp