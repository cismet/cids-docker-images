FROM cismet/cids-java-maven:latest

MAINTAINER Pascal Dihé <pascal.dihe@cismet.de>

LABEL de.cismet.cids.distribution.scaffold.name="cids-distribution-scaffold image" \
      de.cismet.cids.distribution.scaffold.version="cidsDistribution-1.0-0.1" \
      de.cismet.cids.distribution.scaffold.descripton="Scaffold cids distribution Runtime Image" 

# keep DATA_DIR for backwards compatilibity with cids-server-* images
ENV CIDS_DISTRIBUTION_DIR ${DATA_DIR} 
WORKDIR ${CIDS_DISTRIBUTION_DIR}/

COPY cidsDistribution ${CIDS_DISTRIBUTION_DIR}/

VOLUME ${CIDS_DISTRIBUTION_DIR}/

# add /tmp as volume since it may contain data that changes often
VOLUME /tmp

ENTRYPOINT /bin/bash