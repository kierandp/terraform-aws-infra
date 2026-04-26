locals {
  users = merge([
    for role_key, cfg in var.iam_configs : {
      for i in range(cfg.user_count) :
      "${role_key}-${i + 1}" => {
        name = "${role_key}-${i + 1}"
        role = role_key
      }
    }
  ]...)
}