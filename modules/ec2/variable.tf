variable "ec2_configs" {
  type = map(object({
    name          = string
    instance_type = string
    iam_role_key  = string
    sg_keys       = list(string)
  }))
}

variable "private_subnets" {
  type = map(string)
}

variable "sg_ids" {
  type = map(string)
}

variable "iam_role_arns" {
  type = map(string)
}

variable "iam_instance_profiles" {
  type = map(string)
}

variable "target_group_arn" {
  type = map(string)
}

