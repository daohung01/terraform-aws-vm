data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"] 
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  
    tags = {
    "Name" = "custom"
  }
}

resource "aws_subnet" "public_subnet_2a" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = var.availability_zone

  tags = {
    "Name" = "public-subnet"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id 

  tags = {
    "Name" = "custom"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0" # định tuyến gateway subnet ra internet_gateway
    gateway_id = aws_internet_gateway.ig.id # resource internet_gateway
  }

  tags = {
    "Name" = "public"
  }
}

resource "aws_route_table_association" "assoc" {
  subnet_id = aws_subnet.public_subnet_2a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "public" {
  name = "allow_all"
  description = "Allow SSH"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# resource "aws_key_pair" "sshpub" {
#   key_name = "publickey"
#   public_key = var.ssh_public_key
# }

resource "aws_instance" "ec2" {
  count = 2
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.public_subnet_2a.id
  associate_public_ip_address = true
  security_groups = [aws_security_group.public.id]
  key_name = "terraform"
}

