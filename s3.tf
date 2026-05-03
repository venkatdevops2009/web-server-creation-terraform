# Create an S3 bucket

resource "aws_s3_bucket" "bucket" {
  bucket = "bucket9045"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}