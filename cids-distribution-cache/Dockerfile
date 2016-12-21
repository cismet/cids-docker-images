FROM cismet/cids-distribution:latest

MAINTAINER Pascal Dihé <pascal.dihe@cismet.de>

LABEL de.cismet.cids.distribution.cache.name="cids-distribution-cache image" \
      de.cismet.cids.distribution.cache.version="1.0" \
      de.cismet.cids.distribution.cache.tag.docker="1.0" \
      de.cismet.cids.distribution.cache.tag.git="cidsDistributionCache-1.0" \
      de.cismet.cids.distribution.cache.descripton="Optional cache image that contains a pre-filled lib/m2 repository for faster image build" 

# use .dockerignore to control which files go into the image and which not (faster!)
# must contain signed artifacts!
COPY cidsDistribution ${CIDS_DISTRIBUTION_DIR}/
RUN touch ${MAVEN_LIB_DIR}/.signed