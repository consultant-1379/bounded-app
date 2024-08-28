#!/usr/bin/python

import json, httplib

def get_packages_cache_path(iso_version):
    return "/tmp/ERICenm_CXP9027091-%s.json" % iso_version

def get_packages_in_iso(iso_version):
    conn = httplib.HTTPSConnection('cifwk-oss.lmera.ericsson.se', 443)
    conn.request('GET', "/getPackagesInISO/?isoName=ERICenm_CXP9027091&isoVersion=%s" % iso_version)
    return json.loads(conn.getresponse().read())['PackagesInISO']

def get_package_version(version, name):
    conn = httplib.HTTPSConnection('cifwk-oss.lmera.ericsson.se', 443)
    conn.request('GET', "/api/artifact/%s/version/%s/nexusUrl/" %(name, version))
    return json.loads(conn.getresponse().read())[0]


def search_portal_by_name(iso_version, name, version=None):
    if version:
        return get_package_version(version,name)
    else:
        return [p for p in get_packages_in_iso(iso_version) if p['name'] == name][0]
