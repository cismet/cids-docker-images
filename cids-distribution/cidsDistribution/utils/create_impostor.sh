#!/bin/bash

if [[ -z $1 || -z $2 || -z $3 ]] ; then
    echo "Usage: $0 {SERVICE_DIR} {STARTER_JAR} {PROCESS_NAME}"
    exit 1
fi

SERVICE_DIR=$1
STARTER_JAR=$2
PROCESS_NAME=$3

mkdir -p .impostor.tmp
cd .impostor.tmp

jar -xf ${CIDS_STARTER_DIR}/$STARTER_JAR META-INF/MANIFEST.MF
MAIN_CLASS=$(sed -ne '/^Main-Class:/,/Class-Path:/ p' META-INF/MANIFEST.MF | sed -e '/^Class-Path:/ d' -e 's/^ //' | tr -d '\n\r')
rm META-INF/*
echo "creating impostor $PROCESS_NAME for $STARTER_JAR with main class $MAIN_CLASS"
printf "$MAIN_CLASS\n" > MANIFEST.TXT
printf "Class-Path: ${CIDS_STARTER_DIR}/$STARTER_JAR\n">> MANIFEST.TXT
jar -cfm $PROCESS_NAME MANIFEST.TXT -C META-INF .
mv $PROCESS_NAME $SERVICE_DIR/$PROCESS_NAME
cd ..
rm -rf .impostor.tmp