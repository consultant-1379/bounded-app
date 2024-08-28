#!/usr/bin/python

import subprocess

from portal import *

#nexus_url = 'https://arm1s11-eiffel004.eiffel.gic.ericsson.se:8443/nexus/content/repositories/releases'
nexus_url = 'https://arm901-eiffel004.athtem.eei.ericsson.se:8443/nexus/service/local/repositories/enm_proxy/content'

def get_package_url(name, iso_version, version=None):
    return search_portal_by_name(iso_version, name, version)['url']

def log_rpms(url):
    with open('installed_rpms.log', 'a') as log_file:
        log_file.write("%s " % (url))

def install_rpm(url):
    subprocess.call(['rpm', '--install', '--verbose', '--hash', '--nodeps', '--force', url])
    log_rpms(url)
