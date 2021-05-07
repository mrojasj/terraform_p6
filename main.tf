# Resources

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  tags = {
	  Name = "vpc-tf"
  }
}

data "aws_availability_zones" "this"{
  state = "available"
}

resource "aws_subnet" "this" {
  count = length(var.snet_cidr_block_list)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.snet_cidr_block_list[count.index]
  availability_zone = data.aws_availability_zones.this.names[count.index % 2 == 0 ? 0 : 1]
  tags = {
	  Name = "snet-tf-0${count.index}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw-tf"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  
  tags = {
    Name = "rt-tf-public"
  }
}

resource "aws_route_table_association" "this" {
  count = floor(length(var.snet_cidr_block_list) / 2)
  subnet_id      = aws_subnet.this[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "main" {
  name        = "sec_tf_main"
  description = "Main security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "SSH PortC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP PortC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sec_tf_main"
  }
}

data "aws_ami" "amz_linux_2" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "web" {
  ami = data.aws_ami.amz_linux_2.id
  instance_type = "t3.micro"
  key_name = var.keyName
  subnet_id = aws_subnet.this[0].id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.main.id]
  tags = {
    Name = "vm-tf-01"
  }
}
