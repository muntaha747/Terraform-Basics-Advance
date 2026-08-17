resource aws_s3_bucket "storage" {
    bucket = var.bucket-name
}


################################################################
# Private s3 Bucket storage no public access
################################################################


resource "aws_s3_bucket_public_access_block" "storage" {
  bucket = var.bucket-name

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

################################################################
# Authentication (Origin Access Control)
################################################################

resource "aws_cloudfront_origin_access_control" "origin_access_control" {
  name                              = "demo-oac"
  description                       = "Example Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

################################################################
# Authorization AWS s3 Bucket Policy with IAM Policy
################################################################

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.storage.id
  depends_on = [aws_s3_bucket_public_access_block.storage]
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontGetObject"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.storage.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.s3_distribution.arn
          }
        }
      },
      {
        Sid    = "AllowCloudFrontListBucket"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:ListBucket"
        Resource = aws_s3_bucket.storage.arn
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.s3_distribution.arn
          }
        }
      }
    ]
  })
}



################################################################
# s3 Bucket Object
################################################################

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.storage.id
  for_each = fileset("${path.module}/www", "**/*")
  key      = each.value
  source   = "${path.module}/www/${each.value}"
  etag = filemd5("${path.module}/www/${each.value}")
  content_type = lookup({})
}

