
from subprocess import call
import os, time, pyinotify, subprocess

LOG = '/var/log/mdt.log'

def create_model_delpoyment_layout_handler(args):
    call(['sh', '/opt/ericsson/nms/litp/etc/puppet/modules/mcollective_agents/files/create_modelRpm_deployment_layout.sh'])

def wait_for_model_deployment_service():
    while not os.path.exists(LOG):
        time.sleep(0.1)

    with open(LOG, 'r') as file:
        text = file.read()
        while not 'Service registered successfully' in text:
            time.sleep(0.2)
            text = file.read()

def start_model_deployment_service_handler(args):
    if os.path.exists(LOG):
        os.remove(LOG)

    properties = ["-D%s=%s" % (k, v) for (k, v) in {
        'log4j.configuration': 'file:/opt/ericsson/ERICmodeldeployment/lib/log4j.properties',
        'mdt.send.events': str(args.send_events).lower()
    }.iteritems() if v]

    proc = subprocess.Popen(['java'] + properties + ['-classpath',
        '/opt/ericsson/ERICmodeldeployment/lib/*:/opt/ericsson/ERICmodeldeployment/lib/plugins/*',
        'com.ericsson.oss.itpf.modeling.mdt.remote.ModelDeploymentServiceStart'])

    with open('/var/run/modeldeployservice.pid', 'w') as pid_file:
        pid_file.write(str(proc.pid))

    wait_for_model_deployment_service()

def start_model_deployment_client_handler(args):
    proc = subprocess.Popen(['java', '-classpath', '/opt/ericsson/ERICmodeldeploymentclient/lib/*',
        'com.ericsson.oss.itpf.modeling.model.deployment.client.main.ModelDeploymentClientStart',
        args.model_directory])

    with open(LOG, 'r') as file:
        while proc.poll() is None:
          where = file.tell()
          line = file.readline()
          if line:
              print line,
          else:
              time.sleep(0.2)
              file.seek(where)

def generate_entities_handler(args):
    call('/opt/ericsson/ERICdpsupgrade/egt/egt.sh')

def add_host_handler(args):
    open('/etc/hosts', 'a').write("127.0.0.1\t%s\n" % args.host)

def define_schema_handler(args):
    call('/opt/ericsson/ERICdpsupgrade/sut/sut.sh')

def start_versant_handler(args):
    call(['/usr/sbin/xinetd', '-stayalive'])
    call_as_versant("startdb %s" % args.db)

def call_as_versant(cmd):
    call(['su', 'versant', '-c'] + [cmd])

def stop_db_handler(args):
    call_as_versant("stopdb %s" % args.db)

def create_db_handler(args):
    call_as_versant('dbid -N')
    call_as_versant("makedb -nofeprofile -beprofile /profile.be %s" % args.db)
    call_as_versant("createdb %s" % args.db)
    stop_db_handler(args)

def watch_models_handler(args):

    def deploy_models(event):
        if(event.mask & pyinotify.IN_CLOSE_WRITE):
            try:
                start_model_deployment_client_handler(args)
            except Exception as e:
                print "Error watching %s: %s" % (args.model_directory, e)

    wm = pyinotify.WatchManager()
    wdd = wm.add_watch(args.model_directory, pyinotify.IN_CLOSE_WRITE, rec=True)
    notifier = pyinotify.Notifier(wm, deploy_models)
    notifier.loop()
