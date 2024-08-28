#!/bin/bash

DEFAULT_NAMESPACE="${NAMESPACE:-default}"
DEFAULT_DOMAIN="${DOMAIN:-cluster.local}"


kafkaBrokers="kafka.${DEFAULT_NAMESPACE}.svc.${DEFAULT_DOMAIN}"
export kafkaBrokers

echo "kafka1=${kafkaBrokers}" >> /ericsson/tor/data/global.properties

sed -i 's/STREAM_INST_ID=.*/STREAM_INST_ID=\"11\"/' /etc/init.d/pmstream
sed -i "s/export LRC=/#&/" /etc/init.d/pmstream

sed -i 's/INTEGRATION_POINT_URI_ARG=\"\-Dintegration.*/INTEGRATION_POINT_URI_ARG=\"\-Dintegration\.point\.uri=local\:\/\/\/opt\/ericsson\/pmstream\/terminator\-standalone\-kafka\/json\/\"/' /opt/ericsson/pmstream/terminator-standalone-kafka/bin/start.sh
sed -i 's/INTEGRATION_POINT_NAME_ARG=\"\-Dintegration.*/INTEGRATION_POINT_NAME_ARG=\"\-Dintegration.point.name=RAW_PUBLISHER_INTEGRATION_POINT\"/' /opt/ericsson/pmstream/terminator-standalone-kafka/bin/start.sh


DOCKER_HOSTNAME="$(hostname)"
sed "s/$DOCKER_HOSTNAME/& str-1-msstr1/" /etc/hosts >> mktemp && truncate --size=0 /etc/hosts && cat mktemp > /etc/hosts && rm -rf mktemp

service network restart

service pmstream restart


finish()
{
        exit
}
trap finish SIGINT

while :; do
        sleep 15
        service pmstream monitor
        MONITOR_CODE=$?
        if [ ${MONITOR_CODE} != 0 ]; then
                logger "pmstream has failed:"
                logger "$(tail -100f /var/ericsson/log/pmstream/default/start.log)"
                logger "$(tail -100f /var/ericsson/log/pmstream/default/terminator-standalone-kafka.log)"
                exit ${MONITOR_CODE};
        fi
done
