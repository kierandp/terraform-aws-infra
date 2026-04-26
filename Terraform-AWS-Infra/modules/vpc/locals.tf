locals {
  public_subnets = {
    for item in flatten([
      for vpc_key, vpc in var.vpc_configs : [
        for idx, cidr in vpc.public_subnet_cidrs : {
          key     = "${vpc_key}-public-${idx}"
          vpc_key = vpc_key
          cidr    = cidr
          az      = vpc.availability_zones[idx % length(vpc.availability_zones)]
          name    = "${vpc_key}-public-${idx + 1}"
          tags    = vpc.tags
        }
      ]
    ]) :
    item.key => item
  }

  private_subnets = {
    for item in flatten([
      for vpc_key, vpc in var.vpc_configs : [
        for idx, cidr in vpc.private_subnet_cidrs : {
          key     = "${vpc_key}-private-${idx}"
          vpc_key = vpc_key
          cidr    = cidr
          az      = vpc.availability_zones[idx % length(vpc.availability_zones)]
          name    = "${vpc_key}-private-${idx + 1}"
          tags    = vpc.tags
        }
      ]
    ]) :
    item.key => item
  }
}