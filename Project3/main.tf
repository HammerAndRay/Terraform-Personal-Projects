# 1) Create VPC
resource "aws_vpc" "Pi-Hole-VPC" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "pi-hole"
  }
}

# 2) Create internet gateway
resource "aws_internet_gateway" "Pi-Hole-IGW" {
  vpc_id = aws_vpc.Pi-Hole-VPC.id

  tags = {
    Name = "pi-hole-igw"
  }
}

# 3) Create route table
resource "aws_route_table" "Pi-Hole-RT" {
  vpc_id = aws_vpc.Pi-Hole-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Pi-Hole-IGW.id
  }

  tags = {
    Name = "pi-hole-rt"
  }
}

# 4) Create a subnet
resource "aws_subnet" "Pi-Hole-Subnet" {
  vpc_id            = aws_vpc.Pi-Hole-VPC.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-2a"

  tags = {
    Name = "pi-hole-subnet"
  }
}

# 5) Associate the route table with the subnet
resource "aws_route_table_association" "Pi-Hole-RT-Association" {
  subnet_id      = aws_subnet.Pi-Hole-Subnet.id
  route_table_id = aws_route_table.Pi-Hole-RT.id
}

# 6) Create a security group to allow port 22, 80, 443, DNS UDP, and DNS TCP
resource "aws_security_group" "Pi-Hole-SG" {
  name        = "Allow SSH, HTTP, HTTPS, DNS-UDP, DNS-TCP"
  description = "Allow SSH, HTTP, HTTPS, DNS-UDP, DNS-TCP access"
  vpc_id      = aws_vpc.Pi-Hole-VPC.id

  # MAKE SURE TO CHANGE THIS TO THE YOUR IP ADDRESS RANGE THE SETUP IS DONE
  ingress {
    description = "Allow SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # MAKE SURE TO CHANGE THIS TO THE YOUR IP ADDRESS RANGE THE SETUP IS DONE
  ingress {
    description = "Allow HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # MAKE SURE TO CHANGE THIS TO THE YOUR IP ADDRESS RANGE THE SETUP IS DONE
  ingress {
    description = "Allow HTTPS access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # MAKE SURE TO CHANGE THIS TO THE YOUR IP ADDRESS RANGE THE SETUP IS DONE
  ingress {
    description = "Allow DNS UDP access"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # MAKE SURE TO CHANGE THIS TO THE YOUR IP ADDRESS RANGE THE SETUP IS DONE
  ingress {
    description = "Allow DNS TCP access"
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # MAKE SURE TO CHANGE THIS TO THE YOUR IP ADDRESS RANGE THE SETUP IS DONE
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "pi-hole-sg"
  }
}

# 6) Create Ubuntu server and install pi-hole
resource "aws_instance" "web-server" {
  ami                         = "ami-0015a39e4b7c0966f" # Ubuntu Server 20.04 LTS (HVM), London
  instance_type               = "t2.micro"
  availability_zone           = "eu-west-2a"
  key_name                    = "PiHole"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.Pi-Hole-SG.id]
  subnet_id                   = aws_subnet.Pi-Hole-Subnet.id
  # We get the public IP address of the instance to the pi hole, also to allow external dns resolution we need to ebable DNSMASQ_LISTENING=bind 
  user_data = <<-EOF
  #!/bin/bash
  sudo apt upgrade -y
  PublicIp=$(curl -sL http://169.254.169.254/latest/meta-data/public-ipv4)  
  Instanceid=$(curl -sL http://169.254.169.254/latest/meta-data/instance-id)
  sudo mkdir /etc/pihole
  sudo bash -c "cat <<EOT >> /etc/pihole/setupVars.conf
  PIHOLE_INTERFACE=eth0
  IPV4_ADDRESS=$PublicIp/20
  IPV6_ADDRESS=
  PIHOLE_DNS_1=8.8.8.8
  PIHOLE_DNS_2=8.8.4.4
  QUERY_LOGGING=true
  INSTALL_WEB_SERVER=true
  INSTALL_WEB_INTERFACE=true
  LIGHTTPD_ENABLED=true
  CACHE_SIZE=10000
  DNS_FQDN_REQUIRED=true
  DNS_BOGUS_PRIV=true
  DNSMASQ_LISTENING=bind 
  WEBPASSWORD=c1ae733a075521b76e0c93475674a824d1e11d91a42db1465df4a9865a25fcf0
  BLOCKING_ENABLED=true
  EOT"
  sudo curl -L https://install.pi-hole.net | sudo bash /dev/stdin --unattended
  pihole -a -p $Instanceid
  EOF

  tags = {
    Name = "pi-hole-web-server"
  }

  depends_on = [
    aws_vpc.Pi-Hole-VPC, aws_internet_gateway.Pi-Hole-IGW, aws_route_table_association.Pi-Hole-RT-Association, aws_security_group.Pi-Hole-SG
  ]
}
