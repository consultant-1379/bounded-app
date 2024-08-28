#!/usr/bin/python

from os.path import splitext, basename
import os
import urllib2
import json
import xml.etree.ElementTree as ElemT


def retrieve_rpm_name_and_version(url):
    rpm_version = splitext(basename(url.rsplit('/', 1)[-1]))[0]
    rpm, version = rpm_version.split('-')
    return {"package": rpm, "version": version}


def get_installed_packages(file_name):
    with open(file_name) as log_file:
        rpm_urls = log_file.read().split()
    return [retrieve_rpm_name_and_version(url) for url in rpm_urls]


def get_docker_image_names():
    url = os.environ.get('JOB_URL')
    url += "config.xml"
    response = urllib2.urlopen(url)
    tree = ElemT.fromstring(response.read())
    return [splitext(basename(repo.text.rsplit('/', 1)[-1]))[0] for repo in tree.findall('.//repoName')]


def generate_json(image, version):
    return {
        'image_version': {
            'image': {
                'name': image
            },
            'version': version
        },
        'package_revision': get_installed_packages('%s-rpms.log' % image)
    }


def make_rest_call(url, data):
    request = urllib2.Request(url, json.dumps(data), {'Content-Type': 'application/json'})
    return urllib2.urlopen(request)


if __name__ == "__main__":
    rest_url = "https://cifwk-oss.lmera.ericsson.se/api/fastcommit/images"
    image_version = os.environ.get('ISO_VERSION')
    for image in get_docker_image_names():
        data = generate_json(image, image_version)
        make_rest_call(rest_url, data)


