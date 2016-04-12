FROM ubuntu

MAINTAINER Jean-Michel Ruiz "jean.ruiz@cismet.de"

# ENV
ENV POSTGRES_PASSWORD postgres
ENV IMPORT_DIR /import
ENV DATA_DIR /data
ENV POSTGRES_DIR ${DATA_DIR}/cids-integration-base
# .sql files in the dumps folder are imported upon start -> docker-volumes
ENV DUMPS_DIR ${IMPORT_DIR}/cids-integration-base
ENV PG_VERSION 9.0.3
ENV GEOS_VERSION 3.3.5
ENV PROJ4_VERSION 4.8.0
ENV POSTGIS_VERSION 1.5.5
ENV LOCALE de_DE
ENV ENCODING UTF-8

WORKDIR /usr/local/

# install dependencies
RUN apt-get update \
  && apt-get install -y build-essential gcc-4.7 libgdal1h libreadline6-dev libxml2 libxml2-dev locales zlib1g-dev

# locale
RUN localedef -i $LOCALE -c -f $ENCODING -A /usr/share/locale/locale.alias ${LOCALE}.${ENCODING}
RUN locale-gen ${LOCALE}.${ENCODING}

ADD https://ftp.postgresql.org/pub/source/v${PG_VERSION}/postgresql-${PG_VERSION}.tar.bz2 src/
RUN cd src/ ; tar -xjvf postgresql-${PG_VERSION}.tar.bz2
RUN cd src/postgresql-${PG_VERSION} ; ./configure CC='gcc-4.7 -m64' --prefix=/usr/local --with-pgport=5432
RUN cd src/postgresql-${PG_VERSION} ; make
RUN cd src/postgresql-${PG_VERSION} ; make install
RUN cd src/postgresql-${PG_VERSION}/contrib ; make all
RUN cd src/postgresql-${PG_VERSION}/contrib ; make install
RUN ldconfig

# build & install geos
ADD http://download.osgeo.org/geos/geos-${GEOS_VERSION}.tar.bz2 src/
RUN cd src/ ; tar -xjvf geos-${GEOS_VERSION}.tar.bz2
RUN cd src/geos-${GEOS_VERSION} ; ./configure
RUN cd src/geos-${GEOS_VERSION} ; make
RUN cd src/geos-${GEOS_VERSION} ; make install
RUN ldconfig

# build & install proj4
ADD http://download.osgeo.org/proj/proj-${PROJ4_VERSION}.tar.gz src/
RUN cd src/ ; tar -xvf proj-${PROJ4_VERSION}.tar.gz
RUN cd src/proj-${PROJ4_VERSION} ; ./configure
RUN cd src/proj-${PROJ4_VERSION} ; make
RUN cd src/proj-${PROJ4_VERSION} ; make install
RUN ldconfig

# build & install postgis
ADD http://download.osgeo.org/postgis/source/postgis-${POSTGIS_VERSION}.tar.gz src/
RUN cd src/ ; tar -xvf postgis-${POSTGIS_VERSION}.tar.gz
RUN cd src/postgis-${POSTGIS_VERSION} ; ./configure
RUN cd src/postgis-${POSTGIS_VERSION} ; make
RUN cd src/postgis-${POSTGIS_VERSION} ; make install
RUN ldconfig

# create postgres user
RUN groupadd postgres
RUN useradd -r postgres -g postgres
RUN echo "postgres:${POSTGRES_PASSWORD}" | chpasswd -e

# create common data directory
RUN mkdir -p ${DATA_DIR}

# create common import directory
RUN mkdir -p ${IMPORT_DIR}
# create dumps directory
RUN mkdir -p ${DUMPS_DIR}

# create postgres data directory
RUN mkdir -p ${POSTGRES_DIR}
RUN chown postgres:postgres ${POSTGRES_DIR}
RUN chmod 700 ${POSTGRES_DIR}

USER postgres
# initdb
RUN initdb \
  --encoding=${ENCODING} \
  --locale=${LOCALE}.${ENCODING} \
  --lc-collate=${LOCALE}.${ENCODING} \
  --lc-monetary=${LOCALE}.${ENCODING} \
  --lc-numeric=${LOCALE}.${ENCODING} \
  --lc-time=${LOCALE}.${ENCODING} \
  -D ${POSTGRES_DIR}

USER root
# conf
RUN echo "host all all 0.0.0.0/0 md5" >> $POSTGRES_DIR/pg_hba.conf
RUN echo "listen_addresses='*'" >> $POSTGRES_DIR/postgresql.conf

USER postgres
RUN pg_ctl -w -D ${POSTGRES_DIR} start \
# set password
  && psql -c "alter role postgres password '${POSTGRES_PASSWORD}'" \
  && createdb template_postgis \
# postgis template
  && psql template_postgis -f src/postgis-${POSTGIS_VERSION}/postgis/postgis.sql \
  && psql template_postgis -f src/postgis-${POSTGIS_VERSION}/spatial_ref_sys.sql \
  && pg_ctl -w -D ${POSTGRES_DIR} stop

USER root
# clean up
RUN apt-get remove --purge --auto-remove -y build-essential gcc-4.7 libreadline6-dev libxml2-dev zlib1g-dev
RUN rm -rf /var/lib/apt/lists/* src/*

# port
EXPOSE 5432

# data
 VOLUME ${DATA_DIR}
#It is important to do it in the right order, because the files inside the container 
#are only copied to the volume by the first container that uses it (and the volume is still empty)

# start
CMD \
  su postgres -c "pg_ctl -w -D ${POSTGRES_DIR} start" && \
  for DUMP_FULL_PATH in ${DUMPS_DIR}/*.sql; \
  do DUMP_FILE=`basename ${DUMP_FULL_PATH}`; \
    DUMP_DB_NAME=${DUMP_FILE%%.sql}; \
    dropdb -U postgres ${DUMP_DB_NAME} 2> /dev/null; \
    createdb -U postgres -T template_postgis ${DUMP_DB_NAME} && \
    psql -U postgres ${DUMP_DB_NAME} < ${DUMP_FULL_PATH}; \
  done && \
  su postgres -c "pg_ctl -w -D ${POSTGRES_DIR} stop" && \
  su postgres -c "postgres -D ${POSTGRES_DIR}"
