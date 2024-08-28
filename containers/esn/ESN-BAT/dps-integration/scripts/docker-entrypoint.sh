#!/bin/bash

#echo "kafka1=172.16.237.1" >> /ericsson/tor/data/global.properties

#echo "172.16.237.6  str-1-reg1      reg1-1-internal" > /etc/hosts
#echo "172.16.237.2  str-1-msstr1      msstr1-1-internal" >> /etc/hosts
#echo "172.16.237.1  str-1-kafka1      kafka1-1-internal" >> /etc/hosts
#echo "172.16.237.4  str-1-apeps1      apeps1-1-internal" >> /etc/hosts
#echo "172.16.237.3  str-1-zoo1      zoo1-1-internal" >> /etc/hosts
#echo "172.16.237.5  str-1-dfwd1      dfwd1-1-internal" >> /etc/hosts

yum install -y ERICenmsgesnstreamterminatordef_CXP9032803

sed -i "s/export LRC=/#&/" /etc/init.d/pmstream
sed -i 's/INTEGRATION_POINT_URI_ARG=\"\-Dintegration.*/INTEGRATION_POINT_URI_ARG=\"\-Dintegration\.point\.uri=local\:\/\/\/opt\/ericsson\/pmstream\/terminator\-standalone\-kafka\/json\/\"/' /opt/ericsson/pmstream/terminator-standalone-kafka/bin/start.sh
sed -i 's/INTEGRATION_POINT_NAME_ARG=\"\-Dintegration.*/INTEGRATION_POINT_NAME_ARG=\"\-Dintegration.point.name=RAW_PUBLISHER_INTEGRATION_POINT\"/' /opt/ericsson/pmstream/terminator-standalone-kafka/bin/start.sh

service pmstream restart

finish()
{
        exit
}
trap finish SIGINT
