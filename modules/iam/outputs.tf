output "role_arns" {
  value = {
    dev = aws_iam_role.s3_backend_role["dev"].arn
  }
}

output "instance_profile_names" {
  value = {
    for k, p in aws_iam_instance_profile.profile :
    k => p.name
  }
}