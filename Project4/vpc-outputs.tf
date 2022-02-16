output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "ec2_instance_public_ip" {
  description = "The public IP address assigned to the instance"
  value       = module.ec2_instance.public_ip
}