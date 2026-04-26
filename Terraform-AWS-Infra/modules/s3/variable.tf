variable "s3_configs" {
  description = "S3 bucket configurations"
  type = map(object({
    bucket_name         = string
    bucket_policy       = optional(string, null)
    versioning_enabled  = bool
    public_access_block = bool
    enable_encryption   = bool
    force_destroy       = bool
    tags                = map(string)
  }))
}