#!/usr/bin/python

import json,sys
from pprint import pprint

with open(sys.argv[1]) as data_file:
    data = json.load(data_file)

for c in data['mediaArtMaps']:
    if c.get('package_revision__category__name', 'No title') == 'model':
       print(c.get('package_revision__artifactId'))

