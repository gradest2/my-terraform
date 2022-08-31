module "rds" {
  source = "git::https://github.com/cloudposse/terraform-aws-rds.git?ref=0.38.8"
  # Cloud Posse recommends pinning every module to a specific version
  # version = "x.x.x"
  namespace = "rds"
  stage     = "dev"
  name      = "ecs-cluster-best"
  #  dns_zone_id                 = "Z89FN1IW975KPE"
  #  host_name                   = "db"
  #  security_group_ids          = ["sg-xxxxxxxx"]
  #  ca_cert_identifier          = "rds-ca-2019"
  #  allowed_cidr_blocks         = ["XXX.XXX.XXX.XXX/32"]
  database_name     = "dblinks"
  database_user     = "fazt"
  database_password = "mypassword"
  database_port     = 3306
  #  multi_az                    = true
  storage_type = "gp2"
  #  allocated_storage           = 100
  #  storage_encrypted           = true
  engine               = "mysql"
  engine_version       = "5.7.17"
  major_engine_version = "5.7"
  instance_class       = "db.t2.micro"
  db_parameter_group   = "mysql5.7"
  option_group_name    = "mysql-options"
  publicly_accessible  = false
  subnet_ids           = data.terraform_remote_state.net.outputs.private_subnets
  vpc_id               = data.terraform_remote_state.net.outputs.vpc_id
  #  snapshot_identifier         = "rds:production-2015-06-26-06-05"
  #  auto_minor_version_upgrade  = true
  #  allow_major_version_upgrade = false
  #  apply_immediately           = false
  maintenance_window      = "Mon:03:00-Mon:04:00"
  skip_final_snapshot     = false
  copy_tags_to_snapshot   = true
  backup_retention_period = 1
  backup_window           = "22:00-03:00"

  # db_parameter = [
  #   { name  = "myisam_sort_buffer_size"   value = "1048576" },
  #   { name  = "sort_buffer_size"          value = "2097152" }
  # ]
  #
  # db_options = [
  #   { option_name = "MARIADB_AUDIT_PLUGIN"
  #       option_settings = [
  #         { name = "SERVER_AUDIT_EVENTS"           value = "CONNECT" },
  #         { name = "SERVER_AUDIT_FILE_ROTATIONS"   value = "37" }
  #       ]
  #   }
  # ]
}
