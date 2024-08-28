#!/bin/bash

. /usr/sbin/VERSANT_CONFIG

sed -i "s#<%= @versant_home %>#$VERSANT_HOME#g" /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/install_server_script.erb
sed -i "s#<%= @server_installation_directory %>#$VERSANT_INSTALL_DIR#g" /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/install_server_script.erb
sed -i "s#<%= @server_installation_property_file %>#$VERSANT_INSTALL_PROP_FILE#g" /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/install_server_script.erb
sed -i "s#<%= @server_installation_log_file %>#$VERSANT_INSTALL_LOG_FILE#g" /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/install_server_script.erb
sed -i "s/<%= @user %>/$VERSANT_USER/g" /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/install_server_script.erb
sed -i "s/<%= @group %>/$VERSANT_USER/g" /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/install_server_script.erb
sed -i "s/<%= @dbid_node %>/$VERSANT_HOST_NAME/g" /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/install_server_script.erb

sed -i "s#<%= @versant_home %>#$VERSANT_HOME#g" /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/start_database.erb
sed -i "s/<%= @dbid_node %>/$VERSANT_HOST_NAME/g" /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/start_database.erb

sed -i "s#<%= @versant_home %>#$VERSANT_HOME#g" /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/versant_db_service_template.erb
sed -i "s/<%= @db_name %>/$DB_NAME/g" /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/versant_db_service_template.erb
sed -i "s/<%= @host %>/$VERSANT_HOST_NAME/g" /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/versant_db_service_template.erb
sed -i "s#<%= @db_config_path %>#$DB_CONFIG_PATH#g" /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/versant_db_service_template.erb
sed -i "s/<%= @user %>/$VERSANT_USER/g" /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/versant_db_service_template.erb
sed -i "s/<%= @sysvol %>/2G  system/g" /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/versant_db_service_template.erb
sed -i "s/<%= @llogvol %>//g" /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/versant_db_service_template.erb
sed -i "s/<%= @plogvol %>//g" /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/versant_db_service_template.erb
sed -i "s/<%= @max_page_buffs %>//g" /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/versant_db_service_template.erb
sed -i "s/<%= @heap_size %>//g" /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/versant_db_service_template.erb
sed -i "s/<%= @heap_size_increment %>//g" /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/versant_db_service_template.erb
sed -i "s/<%= @transaction %>/3000/g" /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/versant_db_service_template.erb
sed -i "s/<%= @class_number %>//g" /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/versant_db_service_template.erb
sed -i "s/<%= @index %>//g" /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/versant_db_service_template.erb
sed -i "s/<%= @allow_implicit_startdb %>/off/g" /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/versant_db_service_template.erb

## oscssd
sed -i "s#<%= @versant_home %>#$VERSANT_HOME#g" /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/oscssd.erb
sed -i "s/<%= @dbid_node %>/$VERSANT_HOST_NAME/g" /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/oscssd.erb
sed -i "s#<%= @ssd_pidfile %>#$DB_SSD_PID_FILE#g" /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/oscssd.erb
sed -i "s#<%= @dbid_file_path %>#$DB_ID_FILE_PATH#g" /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/oscssd.erb
sed -i "s/<%= @user %>/$VERSANT_USER/g" /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/oscssd.erb
sed -i "s/<%= @group %>/$VERSANT_USER/g" /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/oscssd.erb
sed -i "s#<%= @db_config_path %>#$DB_CONFIG_PATH#g" /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/oscssd.erb
sed -i "s/<%= @versant_service_port %>/5019/g" /opt/ericsson/nms/litp/etc/puppet/modules/versant/templates/oscssd.erb

