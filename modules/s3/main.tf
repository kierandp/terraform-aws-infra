resource "aws_s3_bucket" "s3_bucket" {
  for_each = var.s3_configs

  bucket        = each.value.bucket_name
  force_destroy = each.value.force_destroy

  tags = each.value.tags
}

resource "aws_s3_bucket_versioning" "versioning" {
  for_each = var.s3_configs

  bucket = aws_s3_bucket.s3_bucket[each.key].id

  versioning_configuration {
    status = each.value.versioning_enabled ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  for_each = var.s3_configs

  bucket = aws_s3_bucket.s3_bucket[each.key].id

  block_public_acls       = each.value.public_access_block
  block_public_policy     = each.value.public_access_block
  ignore_public_acls      = each.value.public_access_block
  restrict_public_buckets = each.value.public_access_block
}

resource "aws_s3_bucket_policy" "policy" {
  for_each = {
    for k, v in var.s3_configs :
    k => v if v.bucket_policy != null
  }

  bucket = aws_s3_bucket.s3_bucket[each.key].id
  policy = each.value.bucket_policy

  depends_on = [
    aws_s3_bucket_public_access_block.block
  ]
}

resource "aws_kms_key" "key" {
  description             = "S3 encryption key"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "enc" {
  for_each = var.s3_configs

  bucket = aws_s3_bucket.s3_bucket[each.key].id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}