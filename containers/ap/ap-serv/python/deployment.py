import glob, os, subprocess
import xml.etree.ElementTree as ET

def list_models():
    tree = ET.parse('/ericsson/deploymentDescriptions/4svc_enm_physical_production_dd.xml')
    ns = { 'litp': 'http://www.ericsson.com/litp' }
    return [m.text for m in tree.getroot().findall('.//litp:model-package/name', ns)]


def install_mediation_resolvers_handler(args):
    for script in glob.glob("%s/bin/pre-start/*-resolver-dependency.sh" % os.getenv('JBOSS_HOME')):
        subprocess.call(['sh', script])
