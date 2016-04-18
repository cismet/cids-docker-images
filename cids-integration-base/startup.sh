#!/bin/bash

echo '###### INITIALISING CIDS INTEGRATION BASE ######'
rm /tmp/isready.csv 2> /dev/null;
su postgres -c "pg_ctl -w -D ${CIDS_INTEGRATION_BASE_DIR} start"
psql -U postgres -c "DROP TABLE isready" 2> /dev/null;
for DUMP_FULL_PATH in ${CIDS_INTEGRATION_BASE_IMPORT_DIR}/*.sql;
    do DUMP_FILE=`basename ${DUMP_FULL_PATH}`;
    DUMP_DB_NAME=${DUMP_FILE%%.sql};
    echo 'creating database '${DUMP_DB_NAME}' from file '${DUMP_FILE}
    dropdb -U postgres ${DUMP_DB_NAME} 2> /dev/null;
    createdb -U postgres -T template_postgis ${DUMP_DB_NAME}
    psql -U postgres ${DUMP_DB_NAME} < ${DUMP_FULL_PATH};
done
su postgres -c "pg_ctl -w -D ${CIDS_INTEGRATION_BASE_DIR} stop -s -m fast"
touch /tmp/isready.csv
su postgres -c "postgres -D ${CIDS_INTEGRATION_BASE_DIR}"