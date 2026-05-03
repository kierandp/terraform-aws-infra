resource "aws_lb" "alb" {
  for_each = var.alb_configs

  name               = each.value.name
  internal           = false
  load_balancer_type = "application"

  security_groups = [
  var.sg_ids[each.key]["alb"]
  ]

  subnets = [
    for s in each.value.subnet_keys :
    var.subnet_ids[s]
  ]

  tags = {
    Name = each.value.name
  }
}

resource "aws_lb_target_group" "tg" {
  for_each = var.alb_configs

  name     = "${each.value.name}-tg"
  port     = each.value.target_port
  protocol = "HTTP"

  vpc_id = var.vpc_ids[each.key]

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

resource "aws_lb_listener" "listener" {
  for_each = var.alb_configs

  load_balancer_arn = aws_lb.alb[each.key].arn
  port              = each.value.listener_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg[each.key].arn
  }
}