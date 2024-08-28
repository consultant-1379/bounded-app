#!/bin/bash

(time yum install -y ERICenmsgesncoordinationdef_CXP9032781) > /var/log/messages 2>&1

sed -i 's/ERROR/INFO/' /ericsson/kafka/kafka_2.11-0.9.0.0/config/log4j.properties
service zookeeper restart

finish()
{
        exit
}
trap finish SIGINT

while :; do
        sleep 15
	/etc/init.d/zookeeper monitor
	if [ $? -ne 0 ] ; then
  		exit 1
	fi
done

