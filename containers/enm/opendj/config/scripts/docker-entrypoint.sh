#!/bin/bash

add-host-alias $HOSTNAME opendjhost1
service rsyslog start
service opendj start
finish()
{
  exit
}
trap finish SIGINT

while :; do
sleep 15
OPENDJ_PID=`pidof java`;
if [ -z "$OPENDJ_PID" ]; then
        logger "OPENDJ is not running, exiting -1"
        exit -1;
    fi
done

