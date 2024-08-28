FROM    armdocker.rnd.ericsson.se/proj_bounded_application/base/esn-base

ENV 	container docker

COPY    config/scripts/docker-entrypoint.sh /usr/sbin/

RUN     touch /ericsson/tor/data/jmsserver.running && \
	chmod 777 /usr/sbin/docker-entrypoint.sh && \
	yum install -y --downloadonly --downloaddir=/var/www/html/ENM_STREAMING/ ERICenmsgesncoordinationdef_CXP9032781 && \
	yum clean all && \
	createrepo /var/www/html/ENM_STREAMING/

EXPOSE	2181

ENTRYPOINT	["/usr/sbin/docker-entrypoint.sh"]
CMD	["/bin/bash"]
