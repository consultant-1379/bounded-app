#!/usr/bin/python

import json,sys
from pprint import pprint

with open(sys.argv[1]) as data_file:
    data = json.load(data_file)

for c in data['mediaArtMaps']:
    print('https://arm1s11-eiffel004.eiffel.gic.ericsson.se:8443/nexus/content/repositories/'+c.get('package_revision__arm_repo')+'/'+c.get('package_revision__groupId')+"/"+c.get('package_revision__artifactId')+"/"+c.get('package_revision__version')+"/"+c.get('package_revision__artifactId')+"-"+c.get('package_revision__version')+".rpm")

