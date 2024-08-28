#!/bin/bash

(time yum install -y ERICenmsgesnforwarderdecodeddef_CXP9032777) > /var/log/messages 2>&1
sed -i 's/port=/port=10888/' /ericsson/tor/data/esn_forwarder_config/dfwd.ini
sed -i 's/ip=/ip=eventreceiver1-1-internal/' /ericsson/tor/data/esn_forwarder_config/dfwd.ini

service fwdr restart

finish()
{
        exit
}
trap finish SIGINT

while :; do
        sleep 30
        /etc/init.d/fwdr monitor
        if [ $? -ne 0 ] ; then
                exit 1
        fi
done
