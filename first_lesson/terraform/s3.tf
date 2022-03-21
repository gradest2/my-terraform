resource "aws_s3_bucket" "mysql-dump" {
  bucket = "mysqldumpbucket.gerasimov"

  tags = {
    Name = "mysql-dump"
  }
}
