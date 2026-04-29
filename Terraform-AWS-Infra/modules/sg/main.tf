resource "aws_security_group" "alb" {
  for_each = var.sg_configs

  name   = each.value.alb.name
  vpc_id = var.vpc_ids[each.value.vpc_key]

  dynamic "ingress" {
    for_each = each.value.alb.ingress_ports

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

resource "aws_security_group" "app" {
  for_each = var.sg_configs

  name   = each.value.app.name
  vpc_id = var.vpc_ids[each.value.vpc_key]
}

resource "aws_security_group_rule" "app_ingress_from_alb" {
  for_each = {
    for k, cfg in var.sg_configs :
    k => cfg
  }

  type     = "ingress"
  protocol = "tcp"

  from_port = each.value.app.ingress_ports[0]
  to_port   = each.value.app.ingress_ports[0]

  security_group_id        = aws_security_group.app[each.key].id
  source_security_group_id = aws_security_group.alb[each.key].id
}

resource "aws_security_group" "rds" {
  for_each = var.sg_configs

  name   = each.value.rds.name
  vpc_id = var.vpc_ids[each.value.vpc_key]
}

resource "aws_security_group_rule" "rds_ingress_from_app" {
  for_each = {
    for k, cfg in var.sg_configs :
    k => cfg
  }

  type     = "ingress"
  protocol = "tcp"

  from_port = each.value.rds.ingress_ports[0]
  to_port   = each.value.rds.ingress_ports[0]

  security_group_id        = aws_security_group.rds[each.key].id
  source_security_group_id = aws_security_group.app[each.key].id
}