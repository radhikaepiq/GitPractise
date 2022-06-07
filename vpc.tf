resource "aws_vpc" "main" {
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

availability_zone = "ap-south-1"



tags = {

    Name = "Public SubnetRN"

}

}



resource "aws_subnet" "private_subnet" {

vpc_id = aws_vpc.vpc_rad.id

cidr_block ="172.30.12.128/25"

map_public_ip_on_launch ="false"

availability_zone = "ap-south-1"



tags = {

    Name = "Private SubnetRK"

}

}