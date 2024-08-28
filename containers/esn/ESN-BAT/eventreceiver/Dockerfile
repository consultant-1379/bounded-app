FROM    armdocker.rnd.ericsson.se/proj_bounded_application/base/esn-base

ENV     container docker

COPY    eventReceiverPackage/ERICTAFesn_nettyClient-bin.tar.gz /esn/
COPY    scripts/docker-entrypoint.sh /usr/sbin/

RUN     mkdir -p /esn/ && \
	chmod 777 /usr/sbin/docker-entrypoint.sh

EXPOSE  10888

ENTRYPOINT      ["/usr/sbin/docker-entrypoint.sh"]
CMD     ["/bin/bash"]
