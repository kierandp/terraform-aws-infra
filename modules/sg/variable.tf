variable "vpc_ids" {
  type = map(string)
}

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