output "target_group_arn" {
  value = {
    for k, tg in aws_lb_target_group.tg :
    k => tg.arn
  }
}