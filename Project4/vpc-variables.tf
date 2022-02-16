variable "vpc_name" {
  description = "The name of the VPC"
  default     = "terraform-vpc"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
  type        = string
}

variable "availability_zones" {
  description = "The Availability Zones in which to create the VPC"
  default     = ["us-east-1a"]
  type        = list(string)
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}


variable "vpc_tags" {
  description = "The tags to apply to the VPC"
  default     = "terraform-vpc"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "open_cidr_ipv4" {
  default = "0.0.0.0/0"
}

variable "open_cidr_ipv6" {
  default = "::/0"
}

variable "security_group_name" {
  default = "allow_icmp"
}

variable "security_group_description" {
  default = "Allow ICMP inbound traffic"
}

variable "security_group_tags" {
  default = "terraform-security-group"
}