resource "aws_security_group" "rds-sg" {
  name        = "${var.db_name}-sg"
  description = "${var.db_name}-sg"
  vpc_id      = data.terraform_remote_state.net.outputs.vpc_id

  ingress {
    description = "MYSQL access"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
