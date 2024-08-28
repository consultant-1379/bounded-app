#!groovy

def all_containers = ['versant', 'versant-models', 'postgres', 'enm-jms', 'med-mscm', 'med-msfm', 'med-mspm', 'med-router', 'med-policy', 'med-evbmc', 'med-supcli', 'licence-service', 'sec-service', 'fm-service']
def build_in_parallel_containers = ['postgres', 'enm-jms', 'med-mscm', 'med-msfm', 'med-mspm', 'med-router', 'med-policy', 'med-evbmc', 'med-supcli', 'licence-service', 'sec-service', 'fm-service']

def parallel_build_executions = [:]
def parallel_push_executions = [:]
def parallel_build_dockerfile_executions = [:]

def create_parallel_build_execution(String container, String action) {
    cmd = {
        container:
        {
            sh "cd containers/${container}/ && ./build.sh ${action} ${drop} ${version}"
        }
    }
    return cmd
}


for (int i = 0; i < build_in_parallel_containers.size(); i++) {
    parallel_build_executions[build_in_parallel_containers[i]] = create_parallel_build_execution(build_in_parallel_containers[i], 'build-image')
}

for (int i = 0; i < all_containers.size(); i++) {
    parallel_push_executions[all_containers[i]] = create_parallel_build_execution(all_containers[i], 'push-image')
}

for (int i = 0; i < all_containers.size(); i++) {
    parallel_build_dockerfile_executions[all_containers[i]] = create_parallel_build_execution(all_containers[i], 'create-dockerfile')
}

node {
    stage('Preparation: Get source files') {
        git branch: 'master', credentialsId: 'eafce8ed-856c-4b10-9479-7fba45673ab2', url: 'ssh://edejket@gerrit.ericsson.se:29418/enm-cloud'
    }
    stage('Fetch ISO metadata') {
        sh "cd containers/build && ./build.sh ${drop} ${version}" 
    }	    
    stage('Produce Dockerfile(s)') {
        parallel parallel_build_dockerfile_executions
    }
    stage('Build Ericsson JEE Container') {
        sh "cd containers/ericsson-jee-container/ && ./build.sh build-image ${drop} ${version}"
    }
    stage('Build Versant DB image') {
        sh "cd containers/versant/ && ./build.sh build-image ${drop} ${version}"
    }
    stage('Build model repository and create Versant DB Schemas') {
        sh "cd containers/versant-models/ && ./build.sh build-image ${drop} ${version}"
    }
    stage('Build in parallel Mediation Containers') {
        parallel parallel_build_executions
    }
    stage('Publish to Ericsson registry') {
        parallel parallel_push_executions
    }
}

