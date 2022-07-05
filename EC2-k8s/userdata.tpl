rm /etc/containerd/config.toml
systemctl restart containerd
kubeadm init

kubeadm init --config /etc/kubernetes/aws.yml


#cоздаём файл настроек kubelet (master)
mkdir -p /home/ubuntu/.kube
cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
chown ubuntu:ubuntu /home/ubuntu/.kube/config

#проверяем ноды
su ubuntu
kubectl get nodes -o wide

#Deploying a pod network (https://www.techrepublic.com/article/how-to-quickly-install-kubernetes-on-ubuntu/)
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/k8s-manifests/kube-flannel-rbac.yml
kubectl get pods --all-namespaces
