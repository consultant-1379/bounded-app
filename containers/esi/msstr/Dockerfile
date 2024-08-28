FROM   armdocker.rnd.ericsson.se/proj_bounded_application/base/jdk-base 

RUN    mkdir /etc/cron.d 
RUN    touch /etc/cron.d/ddc

RUN    mkdir -p /ericsson/tor
RUN    mkdir /ericsson/tor/data
RUN    touch /ericsson/tor/data/global.properties
RUN    touch /ericsson/tor/data/jmsserver.running

COPY   scripts/docker-entrypoint.sh /usr/sbin/

RUN    yum install -y ERICenmsgesnstreamterminatordef_CXP9032803

CMD    docker-entrypoint.sh
	
