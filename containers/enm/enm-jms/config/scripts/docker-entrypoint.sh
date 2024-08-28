#!/bin/bash

mkdir -p  /ericsson/tor/data/
touch /ericsson/tor/data/global.properties

service rsyslog start
service jboss start
  
finish()
{
  exit
}
trap finish SIGINT

while :; do
sleep 15
EAP_PID=`pidof java`;
if [ -z "$EAP_PID" ]; then
        logger "EAP is not running, exiting -1"
        exit -1;
    fi
done

