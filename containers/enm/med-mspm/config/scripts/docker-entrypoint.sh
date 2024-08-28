#!/bin/bash


touch /ericsson/tor/data/global.properties
touch /ericsson/tor/data/jmsserver.running


## SET MEM SIZE ##
JVM_MEM_SIZE="${JVM_HEAP_SIZE:-1303}"
JVM_EDEN_SIZE="${JVM_XMN:-1g}"

sed -i -E "s/MEMORY_MAX=([0-9])+/MAX_MEMORY_MAX=$JVM_MEM_SIZE/g" /ericsson/3pp/jboss/jboss-as.conf
sed -i "s/DEFAULT_MEM=\$(memory_max)/DEFAULT_MEM=$JVM_MEM_SIZE/g" /ericsson/3pp/jboss/bin/standalone.conf
sed -i "s/Xmn2g/Xmn$JVM_EDEN_SIZE/g" /ericsson/3pp/jboss/jboss-as.conf

echo "** Setting JVM Xmx parameter to: $JVM_MEM_SIZE"
echo "** Setting JVM Xmn parameter to: $JVM_EDEN_SIZE"
service rsyslog start
service jboss start


finish()
{
	exit
}
trap finish SIGINT

while :; do
	sleep 15
	service jboss monitor
	MONITOR_CODE=$?
	EAP_PID="$(pidof java)"
	if [ ${MONITOR_CODE} != 0 ]; then
		logger "One or more deployments have failed:"
		logger "$(find /ericsson/3pp/jboss/standalone/deployments/ -type f -name \"*.failed\")"
		exit ${MONITOR_CODE};
	fi
	if [ -z "$EAP_PID" ]; then
		logger "EAP is not running, exiting -1"
		exit -1;
	fi
done

