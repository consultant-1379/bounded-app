#!/bin/bash

service crond start

yum install -y ERICenmsgesnbusdef_CXP9032779 > /var/log/messages 2>&1

sed -i 's/ERROR/INFO/'  /ericsson/kafka/kafka_2.11-0.9.0.0/config/log4j.properties

service kafka restart

finish()
{
        exit
}
trap finish SIGINT

while :; do
        sleep 30
        /etc/init.d/kafka monitor
        if [ $? -ne 0 ] ; then
                exit 1
        fi
done

