resource "aws_iam_policy" "k8s-cluster-iam-master-policy" {
  name = "k8s-cluster-iam-master-policy"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "autoscaling:DescribeAutoScalingGroups",
            "autoscaling:DescribeLaunchConfigurations",
            "autoscaling:DescribeTags",
            "ec2:DescribeInstances",
            "ec2:DescribeRegions",
            "ec2:DescribeRouteTables",
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeSubnets",
            "ec2:DescribeVolumes",
            "ec2:CreateSecurityGroup",
            "ec2:CreateTags",
            "ec2:CreateVolume",
            "ec2:ModifyInstanceAttribute",
            "ec2:ModifyVolume",
            "ec2:AttachVolume",
            "ec2:AuthorizeSecurityGroupIngress",
            "ec2:CreateRoute",
            "ec2:DeleteRoute",
            "ec2:DeleteSecurityGroup",
            "ec2:DeleteVolume",
            "ec2:DetachVolume",
            "ec2:RevokeSecurityGroupIngress",
            "ec2:DescribeVpcs",
            "elasticloadbalancing:AddTags",
            "elasticloadbalancing:AttachLoadBalancerToSubnets",
            "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
            "elasticloadbalancing:CreateLoadBalancer",
            "elasticloadbalancing:CreateLoadBalancerPolicy",
            "elasticloadbalancing:CreateLoadBalancerListeners",
            "elasticloadbalancing:ConfigureHealthCheck",
            "elasticloadbalancing:DeleteLoadBalancer",
            "elasticloadbalancing:DeleteLoadBalancerListeners",
            "elasticloadbalancing:DescribeLoadBalancers",
            "elasticloadbalancing:DescribeLoadBalancerAttributes",
            "elasticloadbalancing:DetachLoadBalancerFromSubnets",
            "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
            "elasticloadbalancing:ModifyLoadBalancerAttributes",
            "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
            "elasticloadbalancing:SetLoadBalancerPoliciesForBackendServer",
            "elasticloadbalancing:AddTags",
            "elasticloadbalancing:CreateListener",
            "elasticloadbalancing:CreateTargetGroup",
            "elasticloadbalancing:DeleteListener",
            "elasticloadbalancing:DeleteTargetGroup",
            "elasticloadbalancing:DescribeListeners",
            "elasticloadbalancing:DescribeLoadBalancerPolicies",
            "elasticloadbalancing:DescribeTargetGroups",
            "elasticloadbalancing:DescribeTargetHealth",
            "elasticloadbalancing:ModifyListener",
            "elasticloadbalancing:ModifyTargetGroup",
            "elasticloadbalancing:RegisterTargets",
            "elasticloadbalancing:SetLoadBalancerPoliciesOfListener",
            "iam:CreateServiceLinkedRole",
            "kms:DescribeKey"
          ],
          "Resource" : [
            "*"
          ]
        }
      ]
    }
  )
  tags = {
    "Name" = "k8s-cluster-iam-master-policy"
  }
}

resource "aws_iam_policy" "k8s-cluster-iam-worker-policy" {
  name = "k8s-cluster-iam-worker-policy"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "ec2:DescribeInstances",
            "ec2:DescribeRegions",
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:GetRepositoryPolicy",
            "ecr:DescribeRepositories",
            "ecr:ListImages",
            "ecr:BatchGetImage"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
  tags = {
    "Name" = "k8s-cluster-iam-worker-policy"
  }
}

resource "aws_iam_role" "k8s-cluster-iam-master-role" {
  description        = "Allows EC2 instances to call AWS services on your behalf."
  name               = "k8s-cluster-iam-master-role"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ec2.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
  tags = {
    "Name" = "k8s-cluster-iam-master-role"
  }
}

resource "aws_iam_role" "k8s-cluster-iam-worker-role" {
  description        = "Allows EC2 instances to call AWS services on your behalf."
  name               = "k8s-cluster-iam-worker-role"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ec2.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
  tags = {
    "Name" = "k8s-cluster-iam-worker-role"
  }
}

resource "aws_iam_policy_attachment" "k8s-cluster-iam-master-attachment" {
  name       = "k8s-cluster-iam-master-attachment"
  roles      = [aws_iam_role.k8s-cluster-iam-master-role.name]
  policy_arn = aws_iam_policy.k8s-cluster-iam-master-policy.arn
}

resource "aws_iam_policy_attachment" "k8s-cluster-iam-worker-attachment" {
  name       = "k8s-cluster-iam-worker-attachment"
  roles      = [aws_iam_role.k8s-cluster-iam-worker-role.name]
  policy_arn = aws_iam_policy.k8s-cluster-iam-worker-policy.arn
}


resource "aws_iam_instance_profile" "k8s-cluster-master-profile" {
  name = "service_manager_ec2_profile"
  role = "k8s-cluster-iam-master-role"
}

resource "aws_iam_instance_profile" "k8s-cluster-worker-profile" {
  name = "k8s_worker_profile"
  role = "k8s-cluster-iam-worker-role"
}
