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

  vpc_zone_identifier = [
    var.private_subnets[each.value.subnet_key]
  ]

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