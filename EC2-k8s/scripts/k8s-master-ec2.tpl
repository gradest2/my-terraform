#!/bin/bash


#change hostname
hostnamectl set-hostname $(curl http://169.254.169.254/latest/meta-data/local-hostname)


#set env variables
IPADDR=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
NODENAME=$(hostname)


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

# apt-get install -y kubelet=1.20.6-00 kubectl=1.20.6-00 kubeadm=1.20.6-00
# reference https://stackoverflow.com/questions/49721708/how-to-install-specific-version-of-kubernetes


apt-mark hold kubelet kubeadm kubectl

# fix init errors
rm /etc/containerd/config.toml
systemctl restart containerd

kubeadm init --apiserver-advertise-address=$IPADDR  --apiserver-cert-extra-sans=$IPADDR  --pod-network-cidr=192.168.0.0/16 --node-name $NODENAME --ignore-preflight-errors Swap


mkdir /home/ubuntu/.kube
cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
chown ubuntu:ubuntu /home/ubuntu/.kube/config

curl https://docs.projectcalico.org/manifests/calico.yaml -O

sleep 60

kubectl apply -f calico.yaml
EOF


chmod u+x /tmp/script.sh
sh /tmp/script.sh &> /tmp/script.log
