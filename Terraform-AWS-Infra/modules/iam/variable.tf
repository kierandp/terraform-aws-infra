variable "iam_configs" {
  type = map(object({
    policy             = any
    user_count         = number
    assume_role_policy = any
    tags               = map(string)
  }))
}

