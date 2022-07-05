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
  apt install -y docker-ce kubelet kubeadm kubectl
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

EOF


chmod u+x /tmp/script.sh
sh /tmp/script.sh &> /tmp/script.log
