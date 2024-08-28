#!/bin/sh

. /usr/sbin/VERSANT_CONFIG
### SET HOST ALIAS ###
add-host-alias $HOSTNAME $VERSANT_HOST_NAME

cd /opt/content
cat container_content | xargs -I {} curl -k -O {}

## Install RPMs ##
rpm -ivh --nodeps *.rpm

cd && rm -rf /opt/content

chmod +x /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/*.erb
chown $VERSANT_USER:$VERSANT_USER $VERSANT_HOME/ -R

## PATCH LITP SCRIPTS ##
echo "++Patching litp scripts--"
/usr/sbin/patch_litp_scripts.sh
# COPY SERVICE FILE TO INIT.D ##
echo "++Install oscssd service--"
cp /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/oscssd.erb /etc/init.d/oscssd

### Set correct dir ownership ###
echo "++Change directory ownership to $VERSANT_USER on $VERSANT_HOME--"
chown $VERSANT_USER:$VERSANT_USER $VERSANT_HOME/ -R

## Install our properties file ##
echo "++Update install.properties file with ours--"
mv -f /opt/config/install.properties $VERSANT_HOME/install/

## INSTALL VERSANT SERVER ##
/opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/install_server_script.erb $VERSANT_VERSION
mkdir $DB_ID_FILE_PATH && chown $VERSANT_USER:$VERSANT_USER $DB_ID_FILE_PATH/ -R
/etc/init.d/oscssd start 
/opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/versant_db_service_template.erb start
/opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/versant_db_service_template.erb stop
/etc/init.d/oscssd stop
cp /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/versant_db_service_template.erb /etc/init.d/versant && chmod +x /etc/init.d/versant
echo "********All done********"

