#!/bin/bash

DEFAULT_NAMESPACE="${NAMESPACE:-default}"
DEFAULT_DOMAIN="${DOMAIN:-cluster.local}"


kafkaBrokers="kafka.${DEFAULT_NAMESPACE}.svc.${DEFAULT_DOMAIN}"
export kafkaBrokers

echo "kafka1=${kafkaBrokers}" >> /ericsson/tor/data/global.properties

sed -i 's/model:\/\//local:\/\/\/ericsson\/apeps\/json\//' /var/ericsson/eps/apepsflow/apeps_flow.xml
sed -i 's/EsnLteRanParserSubscriberRaw/RAW_SUBSCRIBER_INTEGRATION_POINT/' /var/ericsson/eps/apepsflow/apeps_flow.xml
sed -i 's/EsnLteRanParserPublisherDecoded/AVRO_PUBLISHER_INTEGRATION_POINT/' /var/ericsson/eps/apepsflow/apeps_flow.xml


DOCKER_HOSTNAME="$(hostname)"
sed "s/$DOCKER_HOSTNAME/& str-1-apeps1/" /etc/hosts >> mktemp && truncate --size=0 /etc/hosts && cat mktemp > /etc/hosts && rm -rf mktemp

service network restart

service apeps restart

finish()
{
        exit
}
trap finish SIGINT

while :; do
        sleep 15
        service apeps monitor
        MONITOR_CODE=$?
        if [ ${MONITOR_CODE} != 0 ]; then
                logger "apeps has failed:"
                exit ${MONITOR_CODE};
        fi
done

