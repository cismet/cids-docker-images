#!/bin/bash

if [[ -z $1 || -z $2 || -z $3 ]] ; then
    echo -e "\e[31mERROR\e[39m: Usage: $0 {KEYSTORE} {STOREPASS} {JARFILE}"
    exit 1
fi

KEYSTORE=$1
STOREPASS=$2
JARFILE=$3

#echo "KEYSTORE: $KEYSTORE"
#echo "STOREPASS: $STOREPASS"
#echo "JARFILE: $JARFILE"

jarsigner -strict -verify -keystore $KEYSTORE -storepass $STOREPASS $JARFILE cismet
if [ $? -eq 0 ]; then
    echo -e "\e[32mINFO\e[39m: \e[1m$JARFILE\e[0m is already signed with cismet certificate"
else
    echo -e "\e[33mNOTICE\e[39m: signing \e[1m$JARFILE\e[0m with cismet certificate"
    zip -q -d $JARFILE META-INF/\*.SF META-INF/\*.RSA META-INF/\*.DSA
    jarsigner -tsa http://sha256timestamp.ws.symantec.com/sha256/timestamp -keystore $KEYSTORE -storepass $STOREPASS $JARFILE cismet
fi