FROM    armdocker.rnd.ericsson.se/proj_bounded_application/base/jdk-base

RUN     ln -s $JAVA_HOME/bin/java /usr/bin/java

RUN     mkdir /etc/cron.d 
RUN     touch /etc/cron.d/ddc

RUN     mkdir -p /ericsson/tor
RUN     mkdir /ericsson/tor/data
RUN     touch /ericsson/tor/data/global.properties
RUN     touch /ericsson/tor/data/jmsserver.running

COPY	scripts/docker-entrypoint.sh /usr/sbin/

RUN     yum install -y ERICenmsgesnmediationdef_CXP9032771

COPY    apepsflow_files/AVRO_PUBLISHER_INTEGRATION_POINT.json  /ericsson/apeps/json/AVRO_PUBLISHER_INTEGRATION_POINT.json
COPY    apepsflow_files/RAW_SUBSCRIBER_INTEGRATION_POINT.json  /ericsson/apeps/json/RAW_SUBSCRIBER_INTEGRATION_POINT.json

CMD     docker-entrypoint.sh
	
