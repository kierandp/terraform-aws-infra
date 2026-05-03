output "role_arns" {
  value = {
    for k, r in aws_iam_role.s3_backend_role :
    k => r.arn
  }
}

output "instance_profile_names" {
  value = {
    for k, p in aws_iam_instance_profile.profile :
    k => p.name
  }
}