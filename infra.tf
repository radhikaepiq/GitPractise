resource "aws_vpc" "vpc_rad" {
  cidr_block       = "172.30.12.0/24"
  instance_tenancy = "default"
  tags = {
    Name = "VPC-demo_rad"
    Purpose = "terrafrom using Jenkins"
  }
}

resource "aws_subnet" "public_subnet" {

vpc_id = aws_vpc.vpc_rad.id

cidr_block ="172.30.12.0/25"

map_public_ip_on_launch ="true"

availability_zone = "ap-south-1a"



tags = {

    Name = "Public SubnetRN"

}

}



resource "aws_subnet" "private_subnet" {

vpc_id = aws_vpc.vpc_rad.id

cidr_block ="172.30.12.128/25"

map_public_ip_on_launch ="false"

availability_zone = "ap-south-1a"



tags = {

    Name = "Private SubnetRK"

}

}