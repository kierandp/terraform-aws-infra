resource "aws_iam_policy" "s3_backend_policy" {
  for_each = var.iam_configs

  name   = each.key
  policy = jsonencode(each.value.policy)

  tags = each.value.tags
}

resource "aws_iam_role" "s3_backend_role" {
  for_each = var.iam_configs

  name               = each.key
  assume_role_policy = jsonencode(each.value.assume_role_policy)
}

resource "aws_iam_role_policy_attachment" "attach" {
  for_each = var.iam_configs

  role       = aws_iam_role.s3_backend_role[each.key].name
  policy_arn = aws_iam_policy.s3_backend_policy[each.key].arn
}


resource "aws_iam_user" "user" {
  for_each = local.users

  name = each.value.name
}

resource "aws_iam_group" "group" {
  for_each = var.iam_configs

  name = "${each.key}-group"
}

resource "aws_iam_group_membership" "membership" {
  for_each = var.iam_configs

  name  = "${each.key}-membership"
  group = aws_iam_group.group[each.key].name

  users = [
    for k, u in aws_iam_user.user :
    u.name if local.users[k].role == each.key
  ]
}

resource "aws_iam_group_policy" "assume_role" {
  for_each = var.iam_configs

  name  = "${each.key}-assume-role"
  group = aws_iam_group.group[each.key].name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "sts:AssumeRole"
      Resource = aws_iam_role.s3_backend_role[each.key].arn
    }]
  })
}

resource "aws_iam_instance_profile" "profile" {
  for_each = var.iam_configs

  name = each.key

  role = aws_iam_role.s3_backend_role[each.key].name
}
