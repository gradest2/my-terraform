variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "db_name" {
  default = "dblinks"
}

variable "tags" {
  default = {
    Environment = "Development"
    Project     = "ECS-CLUSTER-BEST"
  }
  description = "Resource tags"
  type        = map(string)
}
