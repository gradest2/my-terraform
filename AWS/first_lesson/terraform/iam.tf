resource "aws_iam_role" "role_session_manager" {
  name = "role_session_manager"

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
    Role = "role_session_manager"
  }
}

resource "aws_iam_policy" "policy_session_manager" {
  name        = "policy_session_manager"
  description = "policy_session_manager"

  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [
    {
      "Effect" : "Allow",
      "Action" : [
        "ssm:UpdateInstanceInformation",
        "ssmmessages:CreateControlChannel",
        "ssmmessages:CreateDataChannel",
        "ssmmessages:OpenControlChannel",
        "ssmmessages:OpenDataChannel"
      ],
      "Resource" : [
        "*"
      ]
    },
    {
        "Effect": "Allow",
        "Action": [
            "s3:GetEncryptionConfiguration"
        ],
        "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach-session-manager" {
  role       = aws_iam_role.role_session_manager.name
  policy_arn = aws_iam_policy.policy_session_manager.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "service_manager_ec2_profile"
  role = aws_iam_role.role_session_manager.name
}
