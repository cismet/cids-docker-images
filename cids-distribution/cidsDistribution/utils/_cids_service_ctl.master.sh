### GO TO DIRECTORY 
# -----------------------------------------------------------------------------------------
SERVICE_DIR=$((readlink -f $0)|sed "s/cs_ctl.sh//")
echo CD to $SERVICE_DIR
cd $SERVICE_DIR

### IMPOSTORCHECK 
# -----------------------------------------------------------------------------------------
if [ ! -f $PROCESS_NAME ]; then
    ${CIDS_DISTRIBUTION_DIR}/utils/create_impostor.sh $SERVICE_DIR $STARTER_JAR $PROCESS_NAME
    cd $SERVICE_DIR
fi 

case "$1" in

     stop)
        kill  ` cat "$PROCESS_NAME".pid`
	sleep 2

	ps -p ` cat "$PROCESS_NAME".pid`
	FORCE=$?
	if [ $FORCE -eq 0 ]
	 then
	 	echo 'Service: "$PROCESS_NAME" musste mit kill -9 gestoppt werden'
		kill -9 ` cat "$PROCESS_NAME".pid`
		#kill -9  `ps -e -o pid,cmd,args|grep 'D'$CIDS_ACCOUNT_EXTENSION|grep registry|cut -f 1 --delimiter=" "`
	fi

        if [ -x shutdown_hook.sh ]; then
            ./shutdown_hook.sh
        fi     
    ;;
	
    start)
        cmd="java -XX:+HeapDumpOnOutOfMemoryError -Xms$XMS -Xmx$XMX -D{$CIDS_ACCOUNT_EXTENSION}=$PROCESS_NAME -Djava.awt.headless=true -Djava.security.policy=${CIDS_DISTRIBUTION_DIR}/policy.file -jar $PROCESS_NAME"
	echo $cmd
	$cmd&
	echo $! > "$PROCESS_NAME".pid
	ps -p ` cat "$PROCESS_NAME".pid`
	
        if [ -x startup_hook.sh ]; then
            ./startup_hook.sh
        fi 
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