resource "aws_instance" "k8s-master-ec2" {
  user_data            = file("./scripts/k8s-master-ec2.tpl")
  subnet_id            = aws_subnet.k8s-cluster-subnet.id
  ami                  = data.aws_ami.latest_ubuntu.id
  instance_type        = "t2.medium"
  iam_instance_profile = aws_iam_instance_profile.k8s-cluster-master-profile.name
  key_name             = "standart"


  vpc_security_group_ids = [aws_security_group.k8s-master-sg.id]

  root_block_device {
    volume_size = "8"
  }

  tags = {
    Name                               = "k8s-master-ec2"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}

resource "aws_instance" "k8s-worker-ec2" {
  user_data            = file("./scripts/k8s-worker-ec2.tpl")
  ami                  = data.aws_ami.latest_ubuntu.id
  subnet_id            = aws_subnet.k8s-cluster-subnet.id
  instance_type        = "t2.medium"
  iam_instance_profile = aws_iam_instance_profile.k8s-cluster-worker-profile.name
  key_name             = "standart"


  vpc_security_group_ids = [aws_security_group.k8s-worker-sg.id]

  root_block_device {
    volume_size = "8"
  }

  tags = {
    Name                               = "k8s-worker-ec2"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }

  depends_on = [aws_instance.k8s-master-ec2]

}
