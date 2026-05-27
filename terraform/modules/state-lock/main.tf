resource "aws_s3_bucket" "PJrtfstate" {
  bucket = "pjr-terraform-state270526"
}

resource "aws_s3_bucket_versioning" "PJrtfstate" {
  bucket = aws_s3_bucket.PJrtfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "PJrtf_state" {
  bucket = aws_s3_bucket.PJrtfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "PJrtfstate" {
  bucket = aws_s3_bucket.PJrtfstate.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "tf_lock" {
  name         = "Pjr-terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
