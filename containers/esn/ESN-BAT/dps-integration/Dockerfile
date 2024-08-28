FROM armdocker.rnd.ericsson.se/proj_oss_releases/enm/dps-integration-base

COPY scripts/dps_integration_startup.sh /tmp/

RUN yum install -y wget

RUN chmod +x /tmp/dps_integration_startup.sh; /tmp/dps_integration_startup.sh

