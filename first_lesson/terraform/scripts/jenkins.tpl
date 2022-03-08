#!/bin/bash
apt-get -y update

#install docker
apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

#run jenkins (https://hub.docker.com/r/bitnami/jenkins)
docker pull bitnami/jenkins:latest
docker run -d -p 8080:8080 -p 50000:50000 --name jenkins \
 --env JENKINS_USERNAME=mgerasimov \
 --env JENKINS_PASSWORD=ds*931hAA \
 bitnami/jenkins:latest

sudo systemctl restart snap.amazon-ssm-agent.amazon-ssm-agent.service
