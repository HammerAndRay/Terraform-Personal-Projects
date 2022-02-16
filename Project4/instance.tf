# This file will create the pingable instance.
# The lastest linux 2 ami will be used.


# collect the ami of the latest linux 2 
data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
  owners = ["137112412989"] # Amazon
}

# creates the instance in the us-east-1 region with the ami of the latest linux 2 and the instance type of t2.micro
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name          = "terraform-pingable-instance"
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.micro"
  # Select the first value from the list of availability zones
  availability_zone      = element(module.vpc.azs, 0)
  vpc_security_group_ids = [module.security_group.security_group_id]
  # Select the first value from the list of public subnets
  subnet_id                   = element(module.vpc.public_subnets, 0)
  associate_public_ip_address = true

  tags = {
    Name = "Pingable_Instance"
  }
  # Just making sure the vpc is created before the instance
  depends_on = [
    module.vpc
  ]
}