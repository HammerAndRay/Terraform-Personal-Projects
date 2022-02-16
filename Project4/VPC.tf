# This file will create the VPC and security group
# The vpc will span 1 az and will have 3 public subnets and 3 private subnets

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr


  azs             = var.availability_zones
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  # Disabled ipv6 as the module was creating ivp6 infrastructure when it was on. 
  enable_ipv6          = false
  enable_dns_support   = true
  enable_dns_hostnames = true

  # override the default tags for the public subnets
  public_subnet_tags = {
    Name = "Public-Subnet"
  }

  # override the default tags for the private subnets
  private_subnet_tags = {
    Name = "Private-Subnet"
  }

  tags = {
    Name = var.vpc_tags
  }
}

#
# This module will create the security group that allows icmp traffic
module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = var.security_group_name
  description = var.security_group_description
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  # This will allow us to ping the internet (ping is icmp)
  ingress_rules = ["all-icmp"]
  egress_rules  = ["all-all"]

  tags = { Name = var.security_group_tags }
}