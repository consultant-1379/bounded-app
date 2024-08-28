
FROM armdocker.rnd.ericsson.se/proj_bounded_application/base/jdk-base 

MAINTAINER PDLCIAXISC@pdl.internal.ericsson.com

ARG JBOSS_VERSION
ARG NEXUS_BASE=https://arm901-eiffel004.athtem.eei.ericsson.se:8443/nexus/service/local/repositories/thirdparty/content
ARG JBOSS_URL=$NEXUS_BASE/org/jboss/as/jboss-as-dist/$JBOSS_VERSION/jboss-as-dist-$JBOSS_VERSION.zip

#Install NET&SSH tools
RUN yum -y install net-tools openssh-server openssh-clients

#Set root password
RUN echo -e "12shroot\n12shroot" | passwd;

#Start SSH deamon
RUN ssh-keygen -f /root/.ssh/id_rsa


RUN mkdir -p /ericsson/3pp && cd /ericsson/3pp \
 && curl -O $JBOSS_URL                         \
 && jar xvf jboss-as-dist-$JBOSS_VERSION.zip   \
 && rm jboss-as-dist-$JBOSS_VERSION.zip        \
 && mv jboss-eap-* jboss                       \
 && chmod +x jboss/bin/*.sh

ENV JBOSS_HOME=/ericsson/3pp/jboss

EXPOSE 8080 8787 9990 9090 4447

CMD $JBOSS_HOME/bin/standalone.sh -b $HOSTNAME -bmanagement $HOSTNAME --debug

