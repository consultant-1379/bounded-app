#!/bin/bash

add-host-alias $HOSTNAME postgres
service postgresql01  start
finish()
{
	exit
}
trap finish SIGINT

while :; do
	sleep 15
	POSTGRES_PID=`pidof postgres`;
	if [ -z "$POSTGRES_PID" ]; then
		logger "postgres is not running, exiting -1"
		exit -1;
	fi
done

