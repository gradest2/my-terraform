#!/bin/bash


#change hostname
hostnamectl set-hostname $(curl http://169.254.169.254/latest/meta-data/local-hostname)


#define installation script
cat <<EOF > /tmp/script.sh
#! /bin/bash

set -x

# disable swap
swapoff -a
# keeps the swaf off during reboot
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

apt-get update -y
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y
apt-get install docker-ce docker-ce-cli containerd.io -y

# Following configurations are recomended in the kubenetes documentation for Docker runtime. Please refer https://kubernetes.io/docs/setup/production-environment/container-runtimes/#docker

echo "{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}" | tee /etc/docker/daemon.json

systemctl enable docker
systemctl daemon-reload
systemctl restart docker

echo "Docker Runtime Configured Successfully"

apt-get update
apt-get install -y apt-transport-https ca-certificates curl
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

apt-get update -y
apt-get install -y kubelet kubeadm kubectl

apt-mark hold kubelet kubeadm kubectl

# fix init errors
rm /etc/containerd/config.toml
systemctl restart containerd

# add temp join configuration file (join params see in /tmp/script.log)
echo "---
apiVersion: kubeadm.k8s.io/v1beta2
kind: JoinConfiguration
discovery:
  bootstrapToken:
    token: "rat2th.qzmvv988e3pz9ywa[Token]"
    apiServerEndpoint: "10.0.0.102:6443[Master_node]"
    caCertHashes:
      - "sha256:ce983b5fbf4f067176c4641a48dc6f7203d8bef972cb9d2d9bd34831a864d744[Hash]"
nodeRegistration:
  name: ip-10-0-0-186.eu-west-3.compute.internal[worker_node]
  kubeletExtraArgs:
    cloud-provider: aws" | tee /home/ubuntu/node.yml
#[manual]: sudo kubeadm join --config /home/ubuntu/node.yml
EOF


chmod u+x /tmp/script.sh
sh /tmp/script.sh &> /tmp/script.log
