resource "aws_s3_bucket" "example_state_infra_tfstate" {
  bucket = var.state_bucket
}

resource "aws_s3_bucket_versioning" "example_state_infra_tfstate_versioning" {
  depends_on = [
    aws_s3_bucket.example_state_infra_tfstate
  ]

  bucket = aws_s3_bucket.example_state_infra_tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example_state_infra_tfstate_encryption" {
  depends_on = [
    aws_s3_bucket.example_state_infra_tfstate
  ]

  bucket = aws_s3_bucket.example_state_infra_tfstate.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "example_state_infra_tfstate_access" {
  depends_on = [
    aws_s3_bucket.example_state_infra_tfstate
  ]

  bucket                  = aws_s3_bucket.example_state_infra_tfstate.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "example_state_infra_tfstate_locks" {
  name         = var.state_lock_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
