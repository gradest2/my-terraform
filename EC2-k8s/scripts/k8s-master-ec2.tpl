#!/bin/bash

cat <<EOF > /tmp/script.sh
  #!/bin/bash

  apt update && apt -y upgrade

  #добавляем репозитории Docker и Kubernetes
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
  echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
  apt update
  apt-get install -y apt-transport-https ca-certificates curl
  apt install -y docker-ce kubelet kubeadm kubectl
  systemctl enable docker
  systemctl start docker
  hostnamectl set-hostname $(curl http://169.254.169.254/latest/meta-data/local-hostname)
  hostname
  swapoff -a

  cat <<EOF > /etc/kubernetes/aws.yml
---
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
networking:
  serviceSubnet: "10.100.0.0/16"
  podSubnet: "10.244.0.0/16"
apiServer:
  extraArgs:
    cloud-provider: "aws"
controllerManager:
  extraArgs:
    cloud-provider: "aws"
EOF

### cоздаём кластер
kubeadm init --config /etc/kubernetes/aws.yml

### cоздаём файл настроек kubelet (master)
mkdir -p /home/ubuntu/.kube
cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
chown ubuntu:ubuntu /home/ubuntu/.kube/config

#Deploying a pod network (https://www.techrepublic.com/article/how-to-quickly-install-kubernetes-on-ubuntu/) https://linuxconfig.org/how-to-install-kubernetes-on-ubuntu-22-04-jammy-jellyfish-linux
su ubuntu
kubectl get nodes -o wide
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/k8s-manifests/kube-flannel-rbac.yml
kubectl get pods --all-namespaces

EOF


chmod u+x /tmp/script.sh
sh /tmp/script.sh &> /tmp/script.log
