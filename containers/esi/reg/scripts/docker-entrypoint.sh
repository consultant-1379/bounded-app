#!/bin/bash

DEFAULT_NAMESPACE="${NAMESPACE:-default}"
DEFAULT_DOMAIN="${DOMAIN:-cluster.local}"


kafkaBrokers="kafka.${DEFAULT_NAMESPACE}.svc.${DEFAULT_DOMAIN}"
export kafkaBrokers

echo "kafka1=${kafkaBrokers}" >> /ericsson/tor/data/global.properties
echo "zoo1=zoo1.${DEFAULT_NAMESPACE}.svc.${DEFAULT_DOMAIN}" >> /ericsson/tor/data/global.properties

## SET MEM SIZE ##
JVM_MEM_SIZE="${JVM_HEAP_SIZE:-1303}"
sed -i -E "s/MEMORY_MAX=([0-9])+/MAX_MEMORY_MAX=$JVM_MEM_SIZE/g" /ericsson/3pp/jboss/jboss-as.conf
sed -i "s/DEFAULT_MEM=\$(memory_max)/DEFAULT_MEM=$JVM_MEM_SIZE/g" /ericsson/3pp/jboss/bin/standalone.conf
echo "** Setting JVM Xmx parameter to: $JVM_MEM_SIZE"

DOCKER_HOSTNAME="$(hostname)"
sed "s/$DOCKER_HOSTNAME/& str-1-reg1/" /etc/hosts >> mktemp && truncate --size=0 /etc/hosts && cat mktemp > /etc/hosts && rm -rf mktemp


service network restart
service registry start
service rsyslog start
service jboss start


finish()
{
        exit
}
trap finish SIGINT

while :; do
        sleep 15
        service registry monitor
        MONITOR_CODE=$?
        if [ ${MONITOR_CODE} != 0 ]; then
                logger "Schema Registry not running"
                exit ${MONITOR_CODE};
        fi
        service jboss monitor
        MONITOR_CODE=$?
        if [ ${MONITOR_CODE} != 0 ]; then
                logger "jboss not running:"
                logger "$(find /ericsson/3pp/jboss/standalone/deployments/ -type f -name \"*.failed\")"
                exit ${MONITOR_CODE};
        fi
done

