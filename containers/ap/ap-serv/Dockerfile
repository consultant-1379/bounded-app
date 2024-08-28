FROM    armdocker.rnd.ericsson.se/proj_bounded_application/base/jboss-as

COPY 	python/*.py /enm/
RUN 	ln -s /enm/enm.py /usr/bin/enm

RUN    mkdir /etc/cron.d
RUN    touch /etc/cron.d/ddc

RUN     groupadd jboss
RUN 	useradd jboss_user -g jboss
RUN 	useradd litp_jboss
RUN 	useradd litp_admin

RUN    	yum install -y rsyslog
RUN    	yum install -y ERICenmsgautoprovisioning_CXP9031667

RUN	sed -i 's/#$ModLoad imudp/$ModLoad imudp/g' /etc/rsyslog.conf  && \
	sed -i 's/#$UDPServerRun 514/$UDPServerRun 514/g' /etc/rsyslog.conf

COPY    jboss-enm/standalone-enm.xml $JBOSS_HOME/standalone/configuration/standalone-enm.xml
#COPY jboss-enm/standalone-dps.xml $JBOSS_HOME/standalone/configuration/standalone-enm.xml
COPY    jboss-enm/*.properties $JBOSS_HOME/standalone/configuration/

ENV     JBOSS_MODULEPATH=/opt/ericsson/jboss/modules:$JBOSS_HOME/modules

ENV     JVM_MEM_SIZE="${JVM_HEAP_SIZE:-1303}"
RUN     sed -i -E "s/MEMORY_MAX=([0-9])+/MAX_MEMORY_MAX=$JVM_MEM_SIZE/g" /ericsson/3pp/jboss/jboss-as.conf
RUN     sed -i "s/DEFAULT_MEM=\$(memory_max)/DEFAULT_MEM=$JVM_MEM_SIZE/g" /ericsson/3pp/jboss/bin/standalone.conf
RUN     echo "** Setting JVM Xmx parameter to: $JVM_MEM_SIZE"
RUN     echo 'JAVA_OPTS="$JAVA_OPTS -XX:MaxPermSize=512m"' >> /ericsson/3pp/jboss/bin/standalone.conf
RUN     touch /ericsson/tor/data/global.properties

CMD IP_ADDRESS=$(hostname --ip-address)                                                 \
 && MCAST_ADDR=224.0.$(((RANDOM%255)+1)).$(((RANDOM%255)+1))                            \
 && MCAST_ADDR2=224.0.$(((RANDOM%255)+1)).$(((RANDOM%255)+1))                           \
 && $JBOSS_HOME/bin/standalone.sh -c standalone-enm.xml                                 \
    -Dcom.ericsson.oss.sdk.node.identifier=$HOSTNAME                                    \
    -Djboss.node.name=$HOSTNAME                                                         \
    -Djboss.tx.node.id=$HOSTNAME                                                        \
    -Dsdk.jgroups.distributed.udp.mcast_addr=$MCAST_ADDR                                \
    -Dsfwk.db.deployment.type=INTEGRATION_TEST                                          \
    -Dsfwk.service.availability.udp.mcast_addr=$MCAST_ADDR2                             \
    -Dorg.jboss.as.logging.per-deployment=false                                         \
    -b $IP_ADDRESS -bremoting $IP_ADDRESS -bmanagement $IP_ADDRESS --debug

