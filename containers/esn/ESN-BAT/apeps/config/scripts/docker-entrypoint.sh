#!/bin/bash

service crond start
(time yum install -y ERICenmsgesnmediationdef_CXP9032771) > /var/log/messages 2>&1

finish()
{
        exit
}
trap finish SIGINT

while :; do
        sleep 30
        /etc/init.d/apeps monitor
        if [ $? -ne 0 ] ; then
                exit 1
        fi
done
