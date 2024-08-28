FROM    armdocker.rnd.ericsson.se/proj_bounded_application/base/esn-base
MAINTAINER "Shanu Dominic" <shanu.dominic@ericsson.com>

ENV     container docker

COPY    target/container_content /opt/content/
COPY    scripts/docker-entrypoint.sh /usr/sbin/

RUN	mkdir -p /ericsson/s3/ && \
	chmod 777 /usr/sbin/docker-entrypoint.sh && \
	cd /opt/content && cat container_content | xargs -I {} curl -k -L -O {} && \
        cd && ls /opt/content && mv /opt/content/S3-*.zip /ericsson/s3/

ENTRYPOINT      ["/usr/sbin/docker-entrypoint.sh"]
CMD ["bash"]
