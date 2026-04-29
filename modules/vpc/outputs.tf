output "vpc_ids" {
  value = {
    for k, v in aws_vpc.main_vpc :
    k => v.id
  }
}

output "private_subnets" {
  value = {
    for k, s in aws_subnet.private :
    k => s.id
  }
}

output "subnet_ids" {
  value = {
    for k, s in merge(aws_subnet.public, aws_subnet.private) :
    k => s.id
  }
}