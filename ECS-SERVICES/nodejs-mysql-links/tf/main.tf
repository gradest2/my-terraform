resource "aws_cloudwatch_log_group" "this" {
  name_prefix       = "nodejs-mysql-links-"
  retention_in_days = 1
}

resource "aws_ecs_task_definition" "this" {
  family = "nodejs-mysql-links"

  container_definitions = <<EOF
[
  {
    "name": "nodejs-mysql-links",
    "image": "901576725721.dkr.ecr.eu-central-1.amazonaws.com/ecr-ecs-cluster-best:master",
    "cpu": 0,
    "memory": 128,
    "environment": [
      {"name": "NODE_ENV",          "value": "development"},
      {"name": "DATABASE_HOST",     "value": "db"},
      {"name": "DATABASE_USER",     "value": "fazt"},
      {"name": "DATABASE_PASSWORD", "value": "mypassword"}
    ],
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "${region}",
        "awslogs-group": "${aws_cloudwatch_log_group.this.name}",
        "awslogs-stream-prefix": "ec2"
      }
    }
  }
]
EOF
}

resource "aws_ecs_service" "this" {
  name            = "nodejs-mysql-links"
  cluster         = data.terraform_remote_state.ecs-cluster.outputs.cluster_id
  task_definition = aws_ecs_task_definition.this.arn

  desired_count = 1

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
}
