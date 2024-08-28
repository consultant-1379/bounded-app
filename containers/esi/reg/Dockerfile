FROM    armdocker.rnd.ericsson.se/proj_bounded_application/base/jboss-as

RUN     mkdir /etc/cron.d 
RUN     touch /etc/cron.d/ddc

RUN     mkdir -p /ericsson/tor
RUN     mkdir /ericsson/tor/data
RUN     touch /ericsson/tor/data/global.properties
RUN     touch /ericsson/tor/data/jmsserver.running
COPY    config/rootCA* /ericsson/tor/data/certificates/

RUN     groupadd mdt
RUN     useradd -g mdt mdtuser
RUN     useradd -g mdt dpsuser

RUN     groupadd jboss
RUN     useradd -g jboss jboss_user

RUN     groupadd litp_jboss
RUN     useradd -g litp_jboss litp_jboss

RUN     echo -e "jboss_user             soft            nproc           32768\n" >> /etc/security/limits.conf && \
        echo -e "jboss_user             hard            nproc           62000\n" >> /etc/security/limits.conf

RUN     mkdir -p /ericsson/pmic1 /ericsson/pmic2 /ericsson/symvol /ericsson/enm/dumps /ericsson/batch /ericsson/config_mgt /ericsson/configuration_management/UpgradeIndependence 

COPY	scripts/docker-entrypoint.sh /usr/sbin/

RUN     yum install -y ERICdpsupgrade_CXP9030472

RUN     yum install -y ERICenmsgesnschemaapidef_CXP9032773

RUN     sed -i 's/THIS_HOST=$($_HOSTNAME)/THIS_HOST=$HOSTNAME/g' /ericsson/3pp/jboss/bin/standalone.conf && \
        sed -i "s/DEFAULT_IP='127.0.0.1'/DEFAULT_IP=\$(hostname -i)/g" /ericsson/3pp/jboss/bin/standalone.conf

RUN     touch /etc/rsyslog.conf

RUN     sed -i 's/#$ModLoad imudp/$ModLoad imudp/g' /etc/rsyslog.conf  && \
        sed -i 's/#$UDPServerRun 514/$UDPServerRun 514/g' /etc/rsyslog.conf

CMD     docker-entrypoint.sh
	
