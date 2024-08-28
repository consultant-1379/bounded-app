#!/bin/bash

service crond start

tar -zxvf /esn/ERICTAFesn_nettyClient-bin.tar.gz -C /esn

cd /esn

nohup java -cp .:EsnNettyTestClient.jar com.ericsson.oss.mediation.esn.shade.client.PerformantEventReceiverClient 10888 5000 &

echo "done"


finish()
{
        exit
}
trap finish SIGINT

while :; do
        sleep 30
        /etc/init.d/crond status
        if [ $? -ne 0 ] ; then
                exit 1
        fi
done
