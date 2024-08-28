#!/bin/bash


ERICSSON_SHARE_DIR="/ericsson"
DPS_ENTITIES_SHARE_DIR="/ericsson/tor/data/dps"
MODELS_SHARE_DIR="/etc/opt/ericsson"

function extract_models {
if [ ! -d "$MODELS_SHARE_DIR" ]; then
	echo -e "Mountpoint $MODELS_SHARE_DIR does not exist. Creating it!\n"
	mkdir -p $MODELS_SHARE_DIR
fi
echo -e "Extracting model repo to $DPS_ENTITIES_SHARE_DIR.\n"
mv /opt/ERICmodeldeployment.tar.gz $MODELS_SHARE_DIR/ && cd $MODELS_SHARE_DIR && tar zxvf ERICmodeldeployment.tar.gz
}

function extract_dps_entities {
if [ ! -d "$DPS_ENTITIES_SHARE_DIR" ]; then
	echo -e "Mountpoint $DPS_ENTITIES_SHARE_DIR does not exist. Creating it!\n"
	mkdir -p $DPS_ENTITIES_SHARE_DIR
fi
echo -e "Extracting ear with generated entities to $DPS_ENTITIES_SHARE_DIR.\n"
mv /opt/dps-generated.tar.gz $DPS_ENTITIES_SHARE_DIR/ && cd $DPS_ENTITIES_SHARE_DIR && tar zxvf dps-generated.tar.gz
mkdir -p $DPS_ENTITIES_SHARE_DIR/ERICdpsupgrade/dps-jpa-ear/runtime
cp $DPS_ENTITIES_SHARE_DIR/ERICdpsupgrade/dps-jpa-ear/generated/*.ear $DPS_ENTITIES_SHARE_DIR/ERICdpsupgrade/dps-jpa-ear/runtime/
}

function extract_versant_data {
if [ ! -d "$ERICSSON_SHARE_DIR" ]; then
	echo -e "Mountpoint $ERICSSON_SHARE_DIR does not exist. Creating it!\n"
	mkdir -p $ERICSSON_SHARE_DIR
fi
echo -e "Extracting dps_integration database files to $ERICSSON_SHARE_DIR.\n"
mv /opt/versant_data.tar.gz $ERICSSON_SHARE_DIR/ && cd $ERICSSON_SHARE_DIR && tar zxvf versant_data.tar.gz
}

function init_container {
add-host-alias $HOSTNAME db1-service
/etc/init.d/oscssd start
}

function run_container {
service versant start
}

function monitor_container {
while :; do
	sleep 10
	OBE_PID=`pidof obe`;
	CLEANBE=`pidof cleanbe`;
	if [ -z "$OBE_PID" ]; then
		logger "OBE is not running, exiting -1"
		exit -1;
	fi
	if [ -z "$CLEANBE" ]; then
		logger "CLEANBE is not running, exiting -1"
		exit -1;
	fi
done
}
### Main starts here ####

case "$1" in
	start)
		extract_dps_entities
		extract_versant_data
		extract_models
		init_container
		run_container
		monitor_container
		RETVAL=$?
		;;
	extract-only)
		extract_dps_entities
		extract_versant_data
		extract_models
		RETVAL=$?
		;;
	start-no-extract)
		init_container
		run_container
		monitor_container
		RETVAL=$?
		;;
	start-no-extract-models)
		extract_dps_entities
		extract_versant_data
		init_container
		run_container
		monitor_container
		RETVAL=$?
		;;
	start-no-extract-versant-data)
		extract_dps_entities
		extract_models
		init_container
		run_container
		monitor_container
		RETVAL=$?
		;;
	start-no-extract-entities)
		extract_versant_data
		extract_models
		init_container
		run_container
		monitor_container
		RETVAL=$?
		;;
	*)
		echo $"Usage: $0 {start|extract-only|start-no-extract|start-no-extract-models|start-no-extract-versant-data|start-no-extract-entities}"
		RETVAL=2
		;;
esac

exit $RETVAL
