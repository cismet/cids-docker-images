#!/bin/bash

function create_db {
    rm -r ${IMPORT_DIR}/${DUMP_DB_NAME}_import.log 2> /dev/null
    rm -r ${IMPORT_DIR}/${DUMP_DB_NAME}_import.err 2> /dev/null

    touch ${IMPORT_DIR}/${DUMP_DB_NAME}_import.log
    touch ${IMPORT_DIR}/${DUMP_DB_NAME}_import.err

    echo -e "\e[32mINFO\e[39m: creating database '${DUMP_DB_NAME}' from dump file '${DUMP_FILE}"
    dropdb --if-exists -U postgres ${DUMP_DB_NAME} 2>> ${IMPORT_DIR}/${DUMP_DB_NAME}_import.err >> ${IMPORT_DIR}/${DUMP_DB_NAME}_import.log
    createdb -U postgres -T template_postgis ${DUMP_DB_NAME} 2>> ${IMPORT_DIR}/${DUMP_DB_NAME}_import.err >> ${IMPORT_DIR}/${DUMP_DB_NAME}_import.log
}

function init_db {
    if [[ -f ${IMPORT_DIR}/cids-init/cids_init_script.sql ]]; then
        echo -e "\e[32mINFO\e[39m: importing cids_init_script from ${IMPORT_DIR}/cids-init/cids_init_script.sql into ${DUMP_DB_NAME}"
        psql -U postgres ${DUMP_DB_NAME} < ${IMPORT_DIR}/cids-init/cids_init_script.sql; 2>> ${IMPORT_DIR}/${DUMP_DB_NAME}_import.err >> ${IMPORT_DIR}/${DUMP_DB_NAME}_import.log
    fi
}

function post_init_db {
    if [[ -f ${IMPORT_DIR}/cids-init/post_init_script.sql ]]; then
        echo -e "\e[32mINFO\e[39m: importing post_init_script from ${IMPORT_DIR}/cids-init/post_init_script.sql into ${DUMP_DB_NAME}"
        psql -h localhost -p 5432 -U postgres ${DUMP_DB_NAME} < ${IMPORT_DIR}/cids-init/post_init_script.sql; 2>> ${IMPORT_DIR}/${DUMP_DB_NAME}_import.err >> ${IMPORT_DIR}/${DUMP_DB_NAME}_import.log
    fi
}

# don't download latest version, load cids_init_script.sql from volume instead!
# curl --output ${IMPORT_DIR}/cids-init/cids_init_script.sql --retry 3 https://raw.githubusercontent.com/cismet/cids-init/dev/cids_init_script.sql

if [[ -f ${IMPORT_DIR}/roles/roles.sql ]]; then
    echo -e "\e[32mINFO\e[39m: importing global roles from ${IMPORT_DIR}/roles/roles.sql"
    psql -U postgres postgres < ${IMPORT_DIR}/roles/roles.sql;
fi

umask 0000

for DUMP_FULL_PATH in ${IMPORT_DIR}/dumps/*.gz; do 
    if [[ -f ${DUMP_FULL_PATH} ]]; then
        echo -e "\e[32mINFO\e[39m: processing ${DUMP_FULL_PATH}"
        DUMP_FILE=`basename ${DUMP_FULL_PATH}`;
        DUMP_DB_NAME=${DUMP_FILE%%.gz};

        create_db
        init_db

        echo -e "\e[32mINFO\e[39m: importing zipped dump file ${DUMP_FILE} into ${DUMP_DB_NAME}"
        gunzip -c ${DUMP_FULL_PATH} | psql -h localhost -p 5432 -U postgres ${DUMP_DB_NAME} 2>> ${IMPORT_DIR}/${DUMP_DB_NAME}_import.err >> ${IMPORT_DIR}/${DUMP_DB_NAME}_import.log

        post_init_db
    fi
done

for DUMP_FULL_PATH in ${IMPORT_DIR}/dumps/*.sql; do 
    if [[ -f ${DUMP_FULL_PATH} ]]; then
        echo -e "\e[32mINFO\e[39m: processing ${DUMP_FULL_PATH}"
        DUMP_FILE=`basename ${DUMP_FULL_PATH}`;
        DUMP_DB_NAME=${DUMP_FILE%%.sql};

        create_db
        init_db

        echo -e "\e[32mINFO\e[39m: importing SQL dump file ${DUMP_FILE} into ${DUMP_DB_NAME}"
        psql -h localhost -p 5432 -U postgres -d ${DUMP_DB_NAME} -b --file ${DUMP_FULL_PATH} 2>> ${IMPORT_DIR}/${DUMP_DB_NAME}_import.err >> ${IMPORT_DIR}/${DUMP_DB_NAME}_import.log

        post_init_db
    fi
done

for DUMP_FULL_PATH in ${IMPORT_DIR}/dumps/*.backup; do 
    if [[ -f ${DUMP_FULL_PATH} ]]; then
        echo -e "\e[32mINFO\e[39m: processing ${DUMP_FULL_PATH}"
        DUMP_FILE=`basename ${DUMP_FULL_PATH}`;
        DUMP_DB_NAME=${DUMP_FILE%%.backup};

        create_db
        init_db

        echo -e "\e[32mINFO\e[39m: importing custom dump file ${DUMP_FILE} into ${DUMP_DB_NAME}"
        pg_restore -h localhost -p 5432 -U postgres -d ${DUMP_DB_NAME} ${DUMP_FULL_PATH} 2>> ${IMPORT_DIR}/${DUMP_DB_NAME}_import.err >> ${IMPORT_DIR}/${DUMP_DB_NAME}_import.log

        post_init_db
    fi
done
