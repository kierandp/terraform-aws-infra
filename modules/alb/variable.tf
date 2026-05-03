variable "alb_configs" {
  type = map(object({
    name           = string
    subnet_keys    = list(string)
    security_group = string
    target_port    = number
    listener_port  = number
  }))
}

variable "subnet_ids" {
  type = map(string)
}

variable "sg_ids" {
  type = map(object({
    app = string
    alb = string
    rds = string
  }))
}

variable "vpc_ids" {
  type = map(string)
}