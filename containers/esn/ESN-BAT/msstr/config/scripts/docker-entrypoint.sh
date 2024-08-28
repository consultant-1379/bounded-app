#!/bin/bash

service crond start

(time yum install -y ERICenmsgesnstreamterminatordef_CXP9032803) > /var/log/messages 2>&1

sed -i "s/export LRC=/#&/" /etc/init.d/pmstream
sed -i 's/$memory_prop/$memory_prop -Djava.net.preferIPv4Stack=true/g' /opt/ericsson/pmstream/terminator-standalone-kafka/bin/start.sh

service pmstream restart

finish()
{
        exit
}
trap finish SIGINT

while :; do
        sleep 30
        /etc/init.d/pmstream monitor
        if [ $? -ne 0 ] ; then
                exit 1
        fi
done

