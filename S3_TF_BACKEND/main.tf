provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "s3-tf-backend" {
  bucket = "mgerasimov.terraform.backend"

  tags = {
    Name = "terraform-backend"
  }
}
