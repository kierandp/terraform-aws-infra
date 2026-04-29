resource "aws_vpc" "main_vpc" {
  for_each = var.vpc_configs

  cidr_block = each.value.vpc_cidr

  tags = each.value.tags
}

resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id            = aws_vpc.main_vpc[each.value.vpc_key].id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(each.value.tags, {
    Name = each.value.name
  })
}

resource "aws_subnet" "private" {
  for_each = local.private_subnets

  vpc_id            = aws_vpc.main_vpc[each.value.vpc_key].id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(each.value.tags, {
    Name = each.value.name
  })
}

resource "aws_internet_gateway" "igw" {
  for_each = var.vpc_configs

  vpc_id = aws_vpc.main_vpc[each.key].id

  tags = {
    Name = "${each.key}-igw"
  }
}

resource "aws_route_table" "public" {
  for_each = var.vpc_configs

  vpc_id = aws_vpc.main_vpc[each.key].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[each.key].id
  }

  tags = {
    Name = "${each.key}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  for_each = local.public_subnets

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public[each.value.vpc_key].id
}