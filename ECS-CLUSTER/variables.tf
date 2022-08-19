variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "cluster_name" {
  default = "ECS-CLUSTER-BEST"
}

variable "tags" {
  default = {
    Environment = "Development"
    Project     = "ECS-CLUSTER-BEST"
  }
  description = "Resource tags"
  type        = map(string)
}
