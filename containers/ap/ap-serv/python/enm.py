#!/usr/bin/python

from deployment import *
from mdt import *
from multiprocessing import Pool
from portal import *
from rpm import *
from subprocess import call
import argparse, sys, subprocess

def install_package(args):
    install_rpm(get_package_url(*args))

def install_packages(pool_size, args):
    Pool(pool_size).map(install_package, args)

def install_handler(args):
    install_package((args.package, args.iso_version, args.version))

def plusplus_handler(args):
    install_packages(args.pool_size, [(p, args.iso_version) for p in args.packages])

def add_user_handler(args):
    call(['useradd', '--user-group', args.username])
    if args.groups:
      for g in args.groups:
          call(['groupadd', '--force', g])
          call(['usermod', '--append', '--groups', g, args.username])
    if args.password:
        read, write = os.pipe()
        os.write(write, "%s:%s" % (args.username, args.password))
        os.close(write)
        call(['chpasswd'], stdin=read)

def list_models_handler(args):
    for m in list_models():
        print m

def transform_line(parts):
    package = parts[0].strip()
    version = parts[1].strip() if len(parts) == 2 else None
    return (package, version)

def batch_install_handler(args):
    lines = [ line.split('=') for line in open(args.file) if line.strip() ]
    packages = [ (p[0], args.iso_version, p[1]) for p in map(transform_line, lines) ]
    install_packages(1, packages)

# enm
parser = argparse.ArgumentParser(prog='enm')
parser.add_argument('--iso-version', help='the iso version', default=os.getenv('ISO_VERSION'))
subparsers = parser.add_subparsers()
# enm install
install = subparsers.add_parser('install', help='install package using specific version')
install.add_argument('package', help='package name e.g. ERICxyz_CXP123')
install.add_argument('--version', help='install specific version', required=True)
install.set_defaults(handler=install_handler)
# enm batch-install
batch_install = subparsers.add_parser('batch-install', help='install dependencies from a file')
batch_install.add_argument('file', help='file containing the list of packages')
batch_install.set_defaults(handler=batch_install_handler)
# enm ++
plusplus = subparsers.add_parser('++', help='install mutiple packages unsing version from enm iso')
plusplus.add_argument('packages', help='package name e.g. ERICxyz_CXP123', nargs='+')
plusplus.add_argument('--pool-size', help='number of threads to execute in parallel', default=4, type=int)
plusplus.set_defaults(handler=plusplus_handler)
# enm add-user
add_user = subparsers.add_parser('add-user', help='add system user')
add_user.add_argument('username')
add_user.add_argument('--groups', help='list of suplementary groups', nargs='+')
add_user.add_argument('--password', help='plain text user passowrd')
add_user.set_defaults(handler=add_user_handler)
#enm list-models
_list_models = subparsers.add_parser('list-models', help='list all models from iso')
_list_models.set_defaults(handler=list_models_handler)
#enm create-model-deployment-layout
create_model_delpoyment_layout = subparsers.add_parser('create-model-deployment-layout', help='run ERIClitpmodeldeployment_CXP9031595')
create_model_delpoyment_layout.set_defaults(handler=create_model_delpoyment_layout_handler)
#enm start-model-deployment-service
start_model_deployment_service = subparsers.add_parser('start-model-deployment-service', help='start model service server')
start_model_deployment_service.set_defaults(handler=start_model_deployment_service_handler)
start_model_deployment_service.add_argument('--send-events', default=False, action='store_true')
#enm start-model-deployment-client
start_model_deployment_client = subparsers.add_parser('start-model-deployment-client', help='run model service client')
start_model_deployment_client.add_argument('--model-directory', default='/etc/opt/ericsson/ERICmodeldeployment/data/execution/toBeInstalled')
start_model_deployment_client.set_defaults(handler=start_model_deployment_client_handler)
#enm generate-entities
generate_entities = subparsers.add_parser('generate-entities', help='run dps egt')
generate_entities.set_defaults(handler=generate_entities_handler)
#enm add-host
add_host = subparsers.add_parser('add-host', help='add new entry to /etc/hosts')
add_host.add_argument('host')
add_host.set_defaults(handler=add_host_handler)
#enm define-schema
define_schema = subparsers.add_parser('define-schema', help='run dps sut')
define_schema.set_defaults(handler=define_schema_handler)
#enm start-versant
start_versant = subparsers.add_parser('start-versant', help='start versant database')
start_versant.add_argument('db', help='database name to start')
start_versant.set_defaults(handler=start_versant_handler)
#enm create-db
create_db = subparsers.add_parser('create-db', help='create database')
create_db.add_argument('db', help='database name to create')
create_db.set_defaults(handler=create_db_handler)
#enm stop-db
stop_db = subparsers.add_parser('stop-db', help='stop database')
stop_db.add_argument('db', help='database name to create')
stop_db.set_defaults(handler=stop_db_handler)
#enm install-mediation-resolvers
install_mediation_resolvers = subparsers.add_parser('install-mediation-resolvers', help='call all /bin/pre-start/*-resolver-dependency.sh')
install_mediation_resolvers.set_defaults(handler=install_mediation_resolvers_handler)
#enm watch-models
watch_models = subparsers.add_parser('watch-models', help='watch a directory for models changes then run mdt')
watch_models.add_argument('--model-directory', default='/models.d')
watch_models.set_defaults(handler=watch_models_handler)

args = parser.parse_args()
args.handler(args)
