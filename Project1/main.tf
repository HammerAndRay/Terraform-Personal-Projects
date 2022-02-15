# 1) Create VPC
resource "aws_vpc" "TF-Project-VPC" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "production"
  }
}

# 2) Create internet gateway
resource "aws_internet_gateway" "TF-Project-IGW" {
  vpc_id = aws_vpc.TF-Project-VPC.id

  tags = {
    Name = "production-igw"
  }
}

# 3) Create route table
resource "aws_route_table" "TF-Project-RT" {
  vpc_id = aws_vpc.TF-Project-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.TF-Project-IGW.id
  }

  tags = {
    Name = "production-rt"
  }
}

# 4) Create a subnet
resource "aws_subnet" "TF-Project-Subnet" {
  vpc_id            = aws_vpc.TF-Project-VPC.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "production-subnet"
  }
}

# 5) Associate the route table with the subnet
resource "aws_route_table_association" "TF-Project-RT-Association" {
  subnet_id      = aws_subnet.TF-Project-Subnet.id
  route_table_id = aws_route_table.TF-Project-RT.id
}

# 6) Create a security group to allow port 22, 80, and 443
resource "aws_security_group" "TF-Project-SG" {
  name        = "Allow SSH, HTTP, HTTPS"
  description = "Allow SSH, HTTP, HTTPS access"
  vpc_id      = aws_vpc.TF-Project-VPC.id

  ingress {
    description = "Allow SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "production-sg"
  }
}
# 7) Create a network interface with an ip in the subnet created in step 4
resource "aws_network_interface" "TF-Project-ENI" {
  subnet_id = aws_subnet.TF-Project-Subnet.id

  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.TF-Project-SG.id]
}

# 8) Assign an elastic ip to the network interface created in step 7
resource "aws_eip" "TF-Project-EIP" {
  vpc                       = true
  network_interface         = aws_network_interface.TF-Project-ENI.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.TF-Project-IGW]
}

# 9) Create Ubuntu server and install apache2
resource "aws_instance" "web-server" {
  ami               = "ami-0e472ba40eb589f49"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  key_name          = "A4L"
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.TF-Project-ENI.id
  }

  user_data = <<-EOF
  #!/bin/bash
  sudo apt update -y
  sudo apt install apache2 -y
  sudo systemctl start apache2
  sudo bash -c 'echo "The first server is online" > /var/www/html/index.html'
  EOF

  tags = {
    Name = "production-web-server"
  }
}
