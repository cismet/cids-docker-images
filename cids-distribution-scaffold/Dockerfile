FROM cismet/cids-distribution:latest

MAINTAINER Pascal Dihé <pascal.dihe@cismet.de>

LABEL de.cismet.cids.distribution.scaffold.name="cids-distribution-scaffold image" \
      de.cismet.cids.distribution.scaffold.version="cidsDistributionScaffold-1.0" \
      de.cismet.cids.distribution.scaffold.descripton="Scaffold cids distribution Runtime Image" 

# use empty account extension -> lib/local and lib/starter
ENV CIDS_ACCOUNT_EXTENSION=""

# assume local libs are required during image build time -> see .local.templates/.contents.txt for explanation
COPY cidsDistribution/lib/.local.templates ${CIDS_DISTRIBUTION_DIR}/lib/local

ENTRYPOINT /bin/bash