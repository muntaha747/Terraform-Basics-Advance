resource "aws_s3_bucket" "s3_bucket" {
  bucket = "muntaha-tech-terraform"
  tags = {
    "env" = "dev"
  }
}
