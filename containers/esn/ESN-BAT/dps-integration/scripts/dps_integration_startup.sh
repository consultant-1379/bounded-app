#!/bin/bash

set -e

#Specify the Nexus group location of the model and the Model name
modelRepoGroup="com/ericsson/oss/services/esn/"
modelName="ERICesnservicemodels_CXP9032801"

RPM_INSTALL_CMD="rpm --install --verbose --hash --nodeps --force"
CURL='/usr/bin/curl -s'
nexus="https://arm1s11-eiffel004.eiffel.gic.ericsson.se:8443/nexus/content/repositories/releases/"
nexusMetaData="/maven-metadata.xml"
delimiter="| tail -5 | head -1 | cut -c16-20"

version="$(eval $CURL \"$nexus$modelRepoGroup$modelName$nexusMetaData\" $delimiter)"

modelRpm=$modelName"-"$version".rpm"
modelRpmPath=$nexus$modelRepoGroup$modelName"/"$version"/"$modelRpm

echo $modelRpmPath

# Download
wget -q -N $modelRpmPath

#Install & Deploy additional RPMs
echo "Installing $modelRpm ..."
$RPM_INSTALL_CMD $modelRpm

/deploy-models.sh

