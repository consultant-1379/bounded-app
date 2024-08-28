FROM    armdocker.rnd.ericsson.se/proj_bounded_application/base/jboss-as

ENV     container docker

COPY    config/scripts/docker-entrypoint.sh /usr/sbin/
RUN	mkdir -p /ericsson/tor/data/certificates
COPY	config/rootCA* /ericsson/tor/data/certificates/

RUN     ln -s $JAVA_HOME/bin/java /usr/bin/java && \
	ln -s $JAVA_HOME/bin/jar /usr/bin/jar && \
        mkdir -p /etc/cron.d && \
        touch /etc/cron.d/ddc && \
        mkdir -p /ericsson/tor/data && \
        touch /ericsson/tor/data/jmsserver.running && \
        groupadd mdt && \
        useradd -g mdt mdtuser && \
        useradd -g mdt dpsuser && \
        groupadd jboss && \
        useradd -g jboss jboss_user && \
        groupadd litp_jboss && \
        useradd -g litp_jboss litp_jboss && \
        echo -e "jboss_user             soft            nproc           32768\n" >> /etc/security/limits.conf && \
        echo -e "jboss_user             hard            nproc           62000\n" >> /etc/security/limits.conf && \
        mkdir -p /ericsson/pmic1 /ericsson/pmic2 /ericsson/symvol /ericsson/enm/dumps /ericsson/batch /ericsson/config_mgt /ericsson/configuration_management/UpgradeIndependence && \
        sed -i 's/THIS_HOST=$($_HOSTNAME)/THIS_HOST=$HOSTNAME/g' /ericsson/3pp/jboss/bin/standalone.conf && \
        sed -i "s/DEFAULT_IP='127.0.0.1'/DEFAULT_IP=\$(hostname -i)/g" /ericsson/3pp/jboss/bin/standalone.conf && \
        touch /etc/rsyslog.conf && \
        sed -i 's/#$ModLoad imudp/$ModLoad imudp/g' /etc/rsyslog.conf  && \
        sed -i 's/#$UDPServerRun 514/$UDPServerRun 514/g' /etc/rsyslog.conf && \
        chmod 777 /usr/sbin/docker-entrypoint.sh && \
	yum install -y nc ERICdpsupgrade_CXP9030472 cronie createrepo && \
	mkdir -p /var/www/html/ENM_STREAMING/  && \
	yum install -y --downloadonly --downloaddir=/var/www/html/ENM_STREAMING/ ERICenmsgesnschemaapidef_CXP9032773

COPY    config/streaming.repo /etc/yum.repos.d/

RUN     yum clean all && \
        createrepo /var/www/html/ENM_STREAMING/

EXPOSE 	8081

ENTRYPOINT      ["/usr/sbin/docker-entrypoint.sh"]
CMD	["/bin/bash"] 
