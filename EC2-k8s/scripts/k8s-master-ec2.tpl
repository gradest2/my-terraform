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

# apt-get install -y kubelet=1.20.6-00 kubectl=1.20.6-00 kubeadm=1.20.6-00
# reference https://stackoverflow.com/questions/49721708/how-to-install-specific-version-of-kubernetes


apt-mark hold kubelet kubeadm kubectl

# fix init errors
rm /etc/containerd/config.toml
systemctl restart containerd

echo "---
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
networking:
  serviceSubnet: "10.100.0.0/16"
  podSubnet: "10.244.0.0/16"
apiServer:
  extraArgs:
    cloud-provider: "aws"
controllerManager:
  extraArgs:
    cloud-provider: "aws"" | tee aws.yml

kubeadm init --config aws.yml


mkdir /home/ubuntu/.kube
cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
chown ubuntu:ubuntu /home/ubuntu/.kube/config

sleep 60

su ubuntu
curl https://docs.projectcalico.org/manifests/calico.yaml -O
kubectl apply -f calico.yaml


#test service configuration. Please apply this file manualy.
echo "kind: Service
apiVersion: v1
metadata:
  name: hello
spec:
  type: LoadBalancer
  selector:
    app: hello
  ports:
    - name: http
      protocol: TCP
      # ELB's port
      port: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello
  template:
    metadata:
      labels:
        app: hello
    spec:
      containers:
        - name: hello
          image: nginx" | tee elb-example.yml
EOF


chmod u+x /tmp/script.sh
sh /tmp/script.sh &> /tmp/script.log
