resource "aws_s3_bucket" "bucket1" {
  count  = 2
  bucket = var.multiple_buckets[count.index]
  tags   = var.tags
}

resource "aws_s3_bucket" "bucket2" {
  for_each = var.bucket_name_set #2 this will loop based on the 
  bucket   = each.value
  tags     = var.tags

  depends_on = [aws_s3_bucket.bucket1] #This will be depending upon 
}


