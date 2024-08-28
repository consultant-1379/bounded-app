FROM registry.access.redhat.com/rhel6/rhel

MAINTAINER PDLCIAXISC@pdl.internal.ericsson.com

###############
# install jdk #
###############

#ARG JDK_URL=http://download.oracle.com/otn-pub/java/jdk/8u73-b02/jdk-8u73-linux-x64.tar.gz
#ARG JDK_DIR=jdk1.8.0_73
ARG JDK_URL=https://edelivery.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.tar.gz
ARG JDK_DIR=jdk1.7.0_79

RUN     mkdir -p /usr/java/default

RUN     touch /etc/yum.repos.d/cifwk.repo
RUN     touch /etc/yum.repos.d/rhel.repo
RUN     touch /etc/yum.repos.d/patches.repo
RUN     echo -e "[cifwkrepo]\nname=Cifwk Repository\nbaseurl=https://cifwk-oss.lmera.ericsson.se/static/staticRepos/ENM/latest\nenabled=1\ngpgcheck=0" >> /etc/yum.repos.d/cifwk.repo
RUN     echo -e "[rhelrepo]\nname=RHEL Repository\nbaseurl=https://cifwk-oss.lmera.ericsson.se/static/staticRepos/RHEL6.6_OS_DVD/latest\nenabled=1\ngpgcheck=0" >> /etc/yum.repos.d/patches.repo
RUN     echo -e "[patchesrepo]\nname=RHEL Patches Repository\nbaseurl=https://cifwk-oss.lmera.ericsson.se/static/staticRepos/RHEL6.6_OS_Patch_Set/latest\nenabled=1\ngpgcheck=0" >> /etc/yum.repos.d/patches.repo

RUN     yum -y update && \
        yum install -y tar.x86_64 && \
        yum clean all

RUN     yum install -y bind-utils

RUN cd /usr/java/default \
 && curl -v -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" $JDK_URL > jdk1.7.0_79.tar.gz \
 && tar --extract --gzip --file jdk1.7.0_79.tar.gz      \
 && rm -rf                                      \
    $JDK_DIR/*src.zip                           \
    $JDK_DIR/lib/missioncontrol                 \
    $JDK_DIR/lib/visualvm                       \
    $JDK_DIR/lib/*javafx*                       \
    $JDK_DIR/jre/lib/plugin.jar                 \
    $JDK_DIR/jre/lib/ext/jfxrt.jar              \
    $JDK_DIR/jre/bin/javaws                     \
    $JDK_DIR/jre/lib/javaws.jar                 \
    $JDK_DIR/jre/lib/desktop                    \
    $JDK_DIR/jre/plugin                         \
    $JDK_DIR/jre/lib/deploy*                    \
    $JDK_DIR/jre/lib/*javafx*                   \
    $JDK_DIR/jre/lib/*jfx*                      \
    $JDK_DIR/jre/lib/amd64/libdecora_sse.so     \
    $JDK_DIR/jre/lib/amd64/libprism_*.so        \
    $JDK_DIR/jre/lib/amd64/libfxplugins.so      \
    $JDK_DIR/jre/lib/amd64/libglass.so          \
    $JDK_DIR/jre/lib/amd64/libgstreamer-lite.so \
    $JDK_DIR/jre/lib/amd64/libjavafx*.so        \
    $JDK_DIR/jre/lib/amd64/libjfx*.so           \
 && mv $JDK_DIR/* .                             \
 && rm -rf $JDK_DIR jdk1.7.0_79.tar.gz

ENV JAVA_HOME=/usr/java/default
ENV PATH=$PATH:$JAVA_HOME/bin
RUN ln -s $JAVA_HOME/bin/java /usr/bin/java
ENV PATH=$PATH:/sbin
ENV PATH=$PATH:/usr/sbin

