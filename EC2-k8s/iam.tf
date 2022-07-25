resource "aws_iam_instance_profile" "k8s-cluster-master-profile" {
  name = "service_manager_ec2_profile"
  role = "k8s-cluster-iam-master-role"
}

resource "aws_iam_instance_profile" "k8s-cluster-worker-profile" {
  name = "k8s_worker_profile"
  role = "k8s-cluster-iam-worker-role"
}
