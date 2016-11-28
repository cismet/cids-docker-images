#!/bin/bash

# General cids server control script

#export CIDS_DISTRIBUTION_DIR=/cidsDistribution <- already set in docker image
#export CIDS_SERVER_DIR=$CIDS_DISTRIBUTION_DIR/server <- already set in docker image

### FUNCTIONS 
# -----------------------------------------------------------------------------------------

cd $CIDS_SERVER_DIR

case "$1" in
    
    stop)
	./070_cs_lagis/cs_ctl stop && sleep 2
	./060_cs_grundis/cs_ctl stop && sleep 2
	./050_cs_belis2/cs_ctl stop && sleep 2
	./040_cs_wunda_live/cs_ctl stop && sleep 2
	./030_cs_broker4externaluse/cs_ctl stop && sleep 2
	./020_cs_broker/cs_ctl stop && sleep 2
	./010_cs_registry/cs_ctl stop && sleep 2

	sleep 5

	ps -ef|grep 'D'$CIDS_ACCOUNT_EXTENSION

        # run kill command 2 times 
	for k in 1 2
	do
		kill -9  `jps | grep "lagis"|cut -f 1 --delimiter=" "`
		kill -9  `jps | grep "grundis"|cut -f 1 --delimiter=" "`
		kill -9  `jps | grep "belis2"|cut -f 1 --delimiter=" "`
		kill -9  `jps | grep "wunda_live"|cut -f 1 --delimiter=" "`
		kill -9  `jps | grep "broker4externaluse"|cut -f 1 --delimiter=" "`
		kill -9  `jps | grep "broker"|cut -f 1 --delimiter=" "`
		kill -9  `jps | grep "registry"|cut -f 1 --delimiter=" "`
    done
    ;;
    
    start)
		./010_cs_registry/cs_ctl start 
		sleep 5 && ./020_cs_broker/cs_ctl start 
		sleep 10 && ./030_cs_broker4externaluse/cs_ctl start
		sleep 10 && ./040_cs_wunda_live/cs_ctl start
		sleep 5 && ./050_cs_belis2/cs_ctl start 
		sleep 5 && ./060_cs_grundis/cs_ctl start 
		sleep 5 && ./070_cs_lagis/cs_ctl start 

    	ps -ef|grep 'D'$CIDS_ACCOUNT_EXTENSION

    ;;
	
    restart)
    	$0 stop
	$0 start
    ;;

    *)
	echo "Usage: $0 {start|stop|restart}"
	exit 1
;;

esac