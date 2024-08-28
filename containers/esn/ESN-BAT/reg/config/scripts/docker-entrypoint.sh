#!/bin/bash

# SET MEM SIZE ##
JVM_MEM_SIZE="${JVM_HEAP_SIZE:-1303}"
sed -i -E "s/MEMORY_MAX=([0-9])+/MAX_MEMORY_MAX=$JVM_MEM_SIZE/g" /ericsson/3pp/jboss/jboss-as.conf
sed -i "s/DEFAULT_MEM=\$(memory_max)/DEFAULT_MEM=$JVM_MEM_SIZE/g" /ericsson/3pp/jboss/bin/standalone.conf
echo "** Setting JVM Xmx parameter to: $JVM_MEM_SIZE"

service rsyslog start
service crond start
sleep 2s &&

(time yum install -y ERICenmsgesnschemaapidef_CXP9032773) > /var/log/messages 2>&1

finish()
{
        exit
}
trap finish SIGINT

while :; do
        sleep 30
        /etc/init.d/registry monitor
        if [ $? -ne 0 ] ; then
                exit 1
        fi
done

