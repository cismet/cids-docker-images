#!/bin/bash

# General cids server control script

#export CIDS_DISTRIBUTION_DIR=/cidsDistribution <- already set in docker image
#export CIDS_SERVER_DIR=$CIDS_DISTRIBUTION_DIR/server <- already set in docker image

export CIDS_LOCAL_DIR=${CIDS_LIB_DIR}/local${CIDS_ACCOUNT_EXTENSION}
export CIDS_STARTER_DIR=${CIDS_LIB_DIR}/starter${CIDS_ACCOUNT_EXTENSION}

### FUNCTIONS 
# -----------------------------------------------------------------------------------------

pattern='^[0-9]{3}-.+$'
cd $CIDS_SERVER_DIR

case "$1" in
    
    stop)
        for dir in *; do
            if [[ -d $server && $server =~ $pattern ]]; then
                processName=cat $CIDS_SERVER_DIR/$server/cs_ctl.sh | grep PROCESS_NAME | cut -f 2 -d "="
                if [[ -z $2 || $2 = $processName ]]; then
                    echo "gracefully stopping $processName cids server process ($server)"
                    ${CIDS_SERVER_DIR}/$server/cs_ctl.sh stop && sleep 2
                fi
            fi
        done

        sleep 5
        ps -ef|grep 'D'${CIDS_ACCOUNT_EXTENSION}

        for dir in *; do
            if [[ -d $server && $server =~ $pattern ]]; then
                processName=cat $CIDS_SERVER_DIR/$server/cs_ctl.sh | grep PROCESS_NAME | cut -f 2 -d "="
                if [[ -z $2 || $2 = $processName ]]; then
                    processId=jps | grep $processName | cut -f 1 --delimiter=" "
                    if [[ -z $processId ]]; then
                        echo "$processName cids server process ($server) gracefully stopped"
                    else
                        echo "forcibly stopping $processName cids server process ($processId)"
                        # run kill command 2 times 
                        for k in 1 2
                            do 
                                kill -9  $processId
                            done
                    fi
                fi
            fi
        done
    ;;
    
    start)
        for server in *; do
            if [[ -d $server && $server =~ $pattern ]]; then
                processName=cat ${CIDS_SERVER_DIR}/$server/cs_ctl.sh | grep PROCESS_NAME | cut -f 2 -d "="
                echo $processName
                if [[ -z $2 || $2 = $processName ]]; then
                    echo "starting $processName cids server process ($server)"
                    $CIDS_SERVER_DIR/$server/cs_ctl.sh start && sleep 10
                fi
            fi
        done

    	ps -ef|grep 'D'${CIDS_ACCOUNT_EXTENSION}
    ;;
	
    restart)
    	$0 stop $2
	$0 start $2
    ;;

    *)
	echo "Usage: $0 {start|stop|restart} {processName (optional)}"
	exit 1
;;

esac
