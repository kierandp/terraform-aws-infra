output "sg_ids" {
  value = {
    for k in keys(var.sg_configs) :
    k => {
      app = aws_security_group.app[k].id
      alb = aws_security_group.alb[k].id
      rds = aws_security_group.rds[k].id
    }
  }
}