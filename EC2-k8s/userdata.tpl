apt update && apt -y upgrade

#добавляем репозитории Docker и Kubernetes
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
apt update
apt install -y docker-ce kubelet kubeadm kubectl


#хостнейм должэен быть вида примерно такого: ip-10-0-0-102.eu-west-3.compute.internal, проверим
hostname
hostnamectl set-hostname

#на мастере создаем кластер
vim /etc/kubernetes/aws.yml

---
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
    cloud-provider: "aws"

kubeadm init --config /etc/kubernetes/aws.yml


#cоздаём файл настроек kubelet (master)
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown ubuntu:ubuntu $HOME/.kube/config

#проверяем ноды
kubectl get nodes -o wide
config view #проверяем конфигурацию
