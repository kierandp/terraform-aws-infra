resource "aws_db_instance" "first_project_db" {
  for_each = var.rds_configs

  identifier = each.key

  engine         = each.value.engine
  engine_version = each.value.engine_version

  instance_class    = each.value.instance_class
  allocated_storage = each.value.allocated_storage

  db_name  = each.value.db_name
  username = each.value.username
  password = each.value.password

  vpc_security_group_ids = [
  var.sg_ids[each.key]["rds"]
  ]
  
  db_subnet_group_name = aws_db_subnet_group.db[each.key].name

  skip_final_snapshot = true

  tags = each.value.tags
}

resource "aws_db_subnet_group" "db" {
  for_each = var.rds_configs

  name = "${each.key}-db-subnet"

subnet_ids = values(var.private_subnets)
}