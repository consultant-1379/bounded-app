docker run --restart always -h myjenkins -d --name=jenkins -p 6060:8080 -p 5050:50000 -v /usr/bin/docker:/usr/bin/docker -v /home/jenkins:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock my_jenkins

