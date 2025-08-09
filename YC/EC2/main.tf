terraform {
  required_version = ">= 1.0.0"

  required_providers {
      yandex = {
        source  = "yandex-cloud/yandex"
        version = "~> 0.136.0"
      }
  }
  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket = "terraform.tfstate"
    region = "ru-central1"
    key    = "dev/EC2/terraform.tfstate"


    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true # Необходимая опция Terraform для версии 1.6.1 и старше.
    skip_s3_checksum            = true # Необходимая опция при описании бэкенда для Terraform версии 1.6.3 и старше.
  }
}

provider "yandex" {
    zone = var.zone
}

locals {
  config = yamldecode(file("../config.yaml"))
}