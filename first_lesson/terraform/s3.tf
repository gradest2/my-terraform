resource "aws_s3_bucket" "mysql-dump" {
  bucket = "mysql-dump"

  tags = {
    Name = "mysql-dump"
  }
}
