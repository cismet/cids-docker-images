#!/bin/bash


case "$1" in
    
    stop)
        echo -e "\e[32mINFO\e[39m: Stopping cids integrationbase PostgreSQL service"
    
        # "Fast" mode does not wait for clients to disconnect and will terminate an online backup in progress.
        #su postgres -c "pg_ctl -w -D ${CIDS_INTEGRATION_BASE_DIR} stop -m fast"

        # "Smart" mode (the default) waits for all active clients to disconnect and any online backup to finish.
        rm /tmp/isready.csv 2> /dev/null;
        psql -U postgres -c "DROP TABLE isready" 2> /dev/null;
        su postgres -c "pg_ctl -w -D ${PG_DATA_DIR} stop -m smart"
        echo -e "\e[32mINFO\e[39m: cids integrationbase PostgreSQL service stopped"
    ;;
    
    start)
        echo -e "\e[32mINFO\e[39m: Starting cids integrationbase PostgreSQL service"

        rm /tmp/isready.csv 2> /dev/null;
        su postgres -c "pg_ctl -w -D ${PG_DATA_DIR} start"
        psql -U postgres -c "DROP TABLE isready" 2> /dev/null;

        if [ "$2" = "import" ]; then
            echo -e "\e[32mINFO\e[39m: Importing database dumps from host volume mounted to ${IMPORT_DIR}"
            ${CIDS_INTEGRATION_BASE_DIR}/utils/import.sh
        fi

        touch /tmp/isready.csv
        echo -e "\e[32m$(date)\e[39m: cids integrationbase PostgreSQL service running"
     ;;
    
    restart)
        echo -e "\e[32mINFO\e[39m: Restarting cids integrationbase PostgreSQL service"

        rm /tmp/isready.csv 2> /dev/null;
        psql -U postgres -c "DROP TABLE isready" 2> /dev/null;
        su postgres -c "pg_ctl -w -D ${PG_DATA_DIR} restart"

        if [ "$2" = "import" ]; then
            echo -e "\e[32mINFO\e[39m: Importing database dumps from host volume mounted to ${IMPORT_DIR}"
            ${CIDS_INTEGRATION_BASE_DIR}/utils/import.sh
        fi

        touch /tmp/isready.csv
        echo -e "\e[32m$(date)\e[39m: cids integrationbase PostgreSQL service restarted"
    ;;

    *)
	echo "Usage: $0 {start import|start|stop|restart}"
	exit 1
    ;;

esac