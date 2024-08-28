FROM    armdocker.rnd.ericsson.se/proj_bounded_application/base/esn-base

ENV     container docker

COPY    config/scripts/docker-entrypoint.sh /usr/sbin/

RUN     touch /ericsson/tor/data/jmsserver.running && \
        chmod 777 /usr/sbin/docker-entrypoint.sh && \
        yum install -y --downloadonly --downloaddir=/var/www/html/ENM_STREAMING/ ERICenmsgesnmediationdef_CXP9032771 && \
        yum clean all && \
        createrepo /var/www/html/ENM_STREAMING/

EXPOSE  20101 63111 63109-63110/udp

ENTRYPOINT      ["/usr/sbin/docker-entrypoint.sh"]
CMD     ["/bin/bash"]
