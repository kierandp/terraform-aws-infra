data "aws_ami" "latest" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_launch_template" "lt" {
  for_each = var.ec2_configs

  name_prefix   = "${each.value.name}-lt-"
  instance_type = each.value.instance_type

  image_id = data.aws_ami.latest.id


vpc_security_group_ids = [
  var.sg_ids["app"]
]

  iam_instance_profile {
    name = var.iam_instance_profiles[each.value.iam_role_key]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = each.value.name
    }
  }
}

resource "aws_autoscaling_group" "asg" {
  for_each = var.ec2_configs

  name = "${each.value.name}-asg"

  min_size         = 1
  max_size         = 3
  desired_capacity = 1

  vpc_zone_identifier = values(var.private_subnets)

  launch_template {
    id      = aws_launch_template.lt[each.key].id
    version = "$Latest"
  }

  target_group_arns = [
    var.target_group_arn[each.key]
  ]
  health_check_type         = "ELB"
  health_check_grace_period = 60
  
}

resource "aws_autoscaling_policy" "scale_out" {
  for_each = var.ec2_configs

  name                   = "${each.value.name}-scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.asg[each.key].name
}

resource "aws_autoscaling_policy" "scale_in" {
  for_each = var.ec2_configs

  name                   = "${each.value.name}-scale-in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.asg[each.key].name
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  for_each = var.ec2_configs

  alarm_name          = "${each.value.name}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70

  alarm_actions = [
    aws_autoscaling_policy.scale_out[each.key].arn
  ]
}

resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  for_each = var.ec2_configs

  alarm_name          = "${each.value.name}-low-cpu"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 30

  alarm_actions = [
    aws_autoscaling_policy.scale_in[each.key].arn
  ]
}