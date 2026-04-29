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

variable "vpc_ids" {
  type = map(string)
}

variable "private_subnets" {
  type = map(string)
}

variable "sg_ids" {
  type = map(string)
}