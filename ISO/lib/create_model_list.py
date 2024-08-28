#!/usr/bin/python

import json,sys
from pprint import pprint

with open(sys.argv[1]) as data_file:
    data = json.load(data_file)

for c in data['mediaArtMaps']:
    if c.get('package_revision__category__name', 'No title') == 'model':
        print('https://arm1s11-eiffel004.eiffel.gic.ericsson.se:8443/nexus/content/repositories/releases/'+c.get('package_revision__groupId')+"/"+c.get('package_revision__artifactId')+"/"+c.get('package_revision__version')+"/"+c.get('package_revision__artifactId')+"-"+c.get('package_revision__version')+".rpm")

