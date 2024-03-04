# vpc_module.tf

variable "vpc_name" {
  description = "The name of the VPC"
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
}

variable "subnet_cidr_blocks" {
  description = "A list of CIDR blocks for the subnets"
  type        = list(string)
}

provider "aws" {
  region = "us-east-1"  # Update with your desired region
}

resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "example" {
  count = length(var.subnet_cidr_blocks)

  cidr_block = var.subnet_cidr_blocks[count.index]
  vpc_id     = aws_vpc.main.id
  availability_zone = "us-east-1a"  # Update with your desired availability zone

  tags = {
    Name = "${var.vpc_name}-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example.id
  }

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_route_table_association" "example" {
  count          = length(var.subnet_cidr_blocks)
  subnet_id      = aws_subnet.example[count.index].id
  route_table_id = aws_route_table.example.id
}
