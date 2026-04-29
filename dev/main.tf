provider "aws" {
    region = "ap-southeast-1"
}

module "main_vpc" {
    source = "../modules/vpc"
    vpc_configs = var.vpc_configs
}

module "s3_bucket" {
source = "../modules/s3"
s3_configs = var.s3_configs
}

terraform {
  backend "s3" {
    bucket = "my-s3-bucket-firstproject-backend-state-v2"
    key    = "path/to/my/key"
    region = "ap-southeast-1"
    use_lockfile = false
  }
}

module "iam" {
    source = "../modules/iam"
    iam_configs = var.iam_configs
}

module "rds" {
  source = "../modules/rds"
  rds_configs = var.rds_configs

  vpc_ids         = module.main_vpc.vpc_ids
  private_subnets = module.main_vpc.private_subnets
  sg_ids          = module.sg.sg_ids
}

module "sg" {
  source = "../modules/sg"
  sg_configs = var.sg_configs
  
  vpc_ids = module.main_vpc.vpc_ids
}

module "ec2" {
  source = "../modules/ec2"
  ec2_configs = var.ec2_configs

  private_subnets = module.main_vpc.private_subnets
  sg_ids = module.sg.sg_ids
  iam_role_arns = module.iam.role_arns
  iam_instance_profiles = module.iam.instance_profile_names
  target_group_arn = module.alb.target_group_arn

}

module "alb" {
  source = "../modules/alb"
  alb_configs = var.alb_configs

  subnet_ids = module.main_vpc.subnet_ids
  sg_ids     = module.sg.sg_ids
  vpc_ids    = module.main_vpc.vpc_ids
}