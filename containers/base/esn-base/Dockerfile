FROM    armdocker.rnd.ericsson.se/proj_bounded_application/base/jdk-base

MAINTAINER "Shanu Dominic" <shanu.dominic@ericsson.com>
ENV     container docker

RUN     yum install -y wget unzip expect perl tcl cronie nc createrepo

COPY    config/streaming.repo /etc/yum.repos.d/

RUN     ln -s $JAVA_HOME/bin/java /usr/bin/java && \
        ln -s $JAVA_HOME/bin/jar /usr/bin/jar && \
        mkdir -p /var/www/html/ENM_STREAMING/ && \
        mkdir -p /ericsson/tor/data/ && \
        createrepo /var/www/html/ENM_STREAMING/ && \
        touch /etc/cron.d/ddc && \
        touch /ericsson/tor/data/jmsserver.running && \
        service crond start

CMD     ["bash"]
