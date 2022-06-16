provider "aws" {
  region = "ap-south-1"
}
# # create vpc

resource "aws_vpc" "vpc_rad" {

cidr_block = "172.30.12.0/24"

  tags = {

    Name = "Rad-vpc"

    Owner = "RadhikaN"

    Purpose = "aws_terraform_learning"

  }

}

# # CREATE PUBLIC SUBNET  

resource "aws_subnet" "public_subnet" {

vpc_id = aws_vpc.vpc_rad.id

cidr_block ="172.30.12.0/25"

map_public_ip_on_launch ="true"

availability_zone = "ap-south-1a"

tags = {

    Name = "Public SubnetRN"

}

}

# # CREATE Private SUBNET 
# resource "aws_subnet" "private_subnet" {

# vpc_id = aws_vpc.vpc_rad.id

# cidr_block ="172.30.12.128/25"

# map_public_ip_on_launch ="false"

# availability_zone = "ap-south-1a"

# tags = {

#     Name = "Private SubnetRK"

# }

# }

# /////IGW///////////////////
resource "aws_internet_gateway" "Rad_IG" {
  vpc_id = aws_vpc.vpc_rad.id
    tags = {
    Name = "Rad_IG"
  }
}
# /////////////Custom route tabel and attache it to public subnet/////
resource "aws_route_table" "pub_RT" {
  vpc_id = aws_vpc.vpc_rad.id
  tags = {
    Name ="Radpub_RT"
  }
}

resource "aws_route_table_association" "AssocRTpub" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.pub_RT.id
}
resource "aws_route" "route_public" {
  route_table_id              = aws_route_table.pub_RT.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.Rad_IG.id
}

# /////////////Custom route tabel and attach it to private subnet/////
# resource "aws_route_table" "pvt_RT" {
#   vpc_id = aws_vpc.vpc_rad.id

#   route {
#     cidr_block = "10.0.1.0/25"
#     gateway_id = aws_internet_gateway.Rad_IG.id
#   }
#   tags = {
#     Name ="Radpvt_RT"
#   }
# }

# resource "aws_route_table_association" "AssocRTpvt" {
#   subnet_id      = aws_subnet.private_subnet.id
#   route_table_id = aws_route_table.pvt_RT.id
# }

#########security group#########
resource "aws_security_group" "RadSG_terraform" {
  vpc_id      = aws_vpc.vpc_rad.id
  name = "RadSG_terraform"
 
  #Incoming traffic
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
}
# #Public subnet and instance 2
resource "aws_spot_instance_request" "rad_Server_pub" {

  ami = "ami-079b5e5b3971bd10d"
  spot_price             = "0.03"
  instance_type          = "t2.micro"
  spot_type              = "one-time"
  wait_for_fulfillment   = "true"
  subnet_id = aws_subnet.public_subnet.id
  key_name               = "SSHKEY_Rad"
  security_groups = [aws_security_group.RadSG_terraform.id]
}

# #Private subnet and instance 2

#   resource "aws_spot_instance_request" "rad_Server_pvt" {

#   ami = "ami-079b5e5b3971bd10d"
#   spot_price             = "0.03"
#   instance_type          = "t2.micro"
#   spot_type              = "one-time"
#   wait_for_fulfillment   = "true"
#   subnet_id = aws_subnet.private_subnet.id
#   key_name               = "SSHKEY_Rad"
#   security_groups = [aws_security_group.RadSG_terraform.id]
# }

  output "instance_ip_pub" {
    value = aws_spot_instance_request.rad_Server_pub.public_ip
    
  }
#  output "instance_ip_pvt" {
# value = aws_spot_instance_request.rad_Server_pvt.private_ip
#  }
 
