FROM centos:6

COPY 	config/scripts/add-host-alias /usr/sbin/

RUN     yum --disableplugin=fastestmirror -y install libxslt java-1.7.0-openjdk java-1.7.0-openjdk-devel lynx libaio libaio-devel tar unzip which nc rsyslog && \
        mkdir -p /usr/java && \
	ln -s /usr/lib/jvm/java-openjdk/ /usr/java/default && \
	yum -y clean all

