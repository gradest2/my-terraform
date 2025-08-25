data "terraform_remote_state" "vpc" {
  backend = "s3"
  config  = {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket = "terraform.tfstate"
    region = "ru-central1"
    key    = "dev/VPC/terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true # Необходимая опция при описании бэкенда для Terraform версии старше 1.6.1.
   }
 }