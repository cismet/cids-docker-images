FROM cismet/cids-distribution:latest

MAINTAINER Pascal Dihé <pascal.dihe@cismet.de>

LABEL de.cismet.cids.distribution.scaffold.name="cids-distribution-scaffold image" \
      de.cismet.cids.distribution.scaffold.version="cidsDistributionScaffold-1.0" \
      de.cismet.cids.distribution.scaffold.descripton="Scaffold cids distribution Runtime Image" 

# use empty account extension -> lib/local and lib/starter
ENV CIDS_ACCOUNT_EXTENSION=""
ENV CIDS_LOCAL_DIR ${CIDS_LIB_DIR}/local${CIDS_ACCOUNT_EXTENSION}
ENV CIDS_STARTER_DIR ${CIDS_LIB_DIR}/starter${CIDS_ACCOUNT_EXTENSION}

# use .dockerignore to control which files go into the image and which not (faster!)
COPY cidsDistribution ${CIDS_DISTRIBUTION_DIR}/

# assume local libs are required during image build time -> see .local.templates/.contents.txt for explanation
# don't add cidsDistribution/lib/.local.templates to .dockerignore in order to make this work
COPY cidsDistribution/lib/.local.templates ${CIDS_DISTRIBUTION_DIR}/lib/local/
RUN rm -rf ${CIDS_DISTRIBUTION_DIR}/lib/.local.templates

#ENTRYPOINT /bin/bash