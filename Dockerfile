FROM jenkins/jenkins:lts
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
#COPY jenkins.yaml /var/jenkins_conf/jenkins.yaml
ENV JAVA_OPTS "-Djenkins.install.runSetupWizard=false"
ENV JENKINS_USER admin
ENV JENKINS_PASS admin
ENV DOCKERVERSION=18.03.1-ce
#ENV CASC_JENKINS_CONFIG /var/jenkins_conf

USER root
# Install maven and other tools
RUN apt-get update && apt-get install -y maven 
RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
  && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 \
                 -C /usr/local/bin docker/docker \
  && rm docker-${DOCKERVERSION}.tgz
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
	&& chmod +x ./kubectl \
	&& mv ./kubectl /usr/local/bin/kubectl
USER jenkins

RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
