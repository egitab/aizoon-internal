resource "aws_s3_bucket" "bucket-test" {
  bucket = "${var.s3_local_bucket}"
}

### Default settings for S3 bucket
# ACL disabled (object ownership enforced)
resource "aws_s3_bucket_ownership_controls" "bucket-ownership-controls" {
  bucket = aws_s3_bucket.bucket-test.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}
# No public access
resource "aws_s3_bucket_public_access_block" "bucket-public-access-block" {
  bucket = aws_s3_bucket.bucket-test.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
# Auto crypt
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket-server-side-encryption" {
  bucket = aws_s3_bucket.bucket-test.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # = SSE-S3 (default console)
    }
    bucket_key_enabled = true
  }
}
###/Default settings for S3 bucket

resource "aws_s3_object" "bucket-test-first-folder" {
  bucket = aws_s3_bucket.bucket-test.id
  key    = "${var.s3_local_folder}/"
  acl    = "private"
}
