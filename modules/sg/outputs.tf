output "sg_ids" {
  value = {
    app = aws_security_group.app["dev"].id
    alb = aws_security_group.alb["dev"].id
    rds = aws_security_group.rds["dev"].id
  }
}