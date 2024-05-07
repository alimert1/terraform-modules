resource "aws_s3_bucket" "bucket_01" {
  bucket = "bucket-name"

  tags = {
    Name      = "limons3"
  }
}




resource "aws_s3_bucket_acl" "bucket_01_acl" {
  bucket = aws_s3_bucket.bucket_01.id
  acl    = "private"
}