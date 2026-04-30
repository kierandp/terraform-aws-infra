# ------------------------------------------------------------------------------
# VPC ARCHITECTURE
# ------------------------------------------------------------------------------

variable "vpc_configs" {
  type = map(object({
    vpc_cidr             = string
    public_subnet_cidrs  = list(string)
    private_subnet_cidrs = list(string)
    availability_zones   = list(string)
    tags                 = map(string)
  }))
}


# ------------------------------------------------------------------------------
# S3 ARCHITECTURE
# ------------------------------------------------------------------------------


variable "s3_configs" {
  description = "Map of s3 configurations"
  type = map(object({
    bucket_name         = string
    bucket_policy       = optional(string, null)
    versioning_enabled  = bool
    public_access_block = bool
    enable_encryption   = bool
    force_destroy       = bool
    tags = map(string)

  }))
}

# ------------------------------------------------------------------------------
# IAM ARCHITECTURE
# # ------------------------------------------------------------------------------

variable "iam_configs" {
  type = map(object({
    user_count         = number
    policy             = any
    assume_role_policy = any
    tags               = map(string)
  }))
}

# ------------------------------------------------------------------------------
# RDS ARCHITECTURE
# ------------------------------------------------------------------------------

variable "rds_configs" {
  type = map(object({
    engine            = string
    engine_version    = string
    instance_class    = string
    allocated_storage = number
    db_name           = string
    username          = string
    password          = string
    tags              = map(string)
  }))
}

# ------------------------------------------------------------------------------
# SG ARCHITECTURE
# ------------------------------------------------------------------------------

variable "sg_configs" {
  type = map(object({
    vpc_key = string

    alb = object({
      name          = string
      ingress_ports = list(number)
    })

    app = object({
      name          = string
      ingress_ports = list(number)
    })

    rds = object({
      name          = string
      ingress_ports = list(number)
    })
  }))
}

# ------------------------------------------------------------------------------
# EC2 ARCHITECTURE
# ------------------------------------------------------------------------------

variable "ec2_configs" {
  type = map(object({
    name          = string
    instance_type = string
    sg_keys       = list(string)
    iam_role_key  = string
    tags          = map(string)

  }))
}

# ------------------------------------------------------------------------------
# ALB ARCHITECTURE
# ------------------------------------------------------------------------------


variable "alb_configs" {
  type = map(object({
    name           = string
    subnet_keys    = list(string)
    security_group = string 
    target_port    = number
    listener_port  = number
    tags           = map(string)
  }))
}