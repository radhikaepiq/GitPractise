# create vpc

resource "aws_vpc" "vpc_rad" {

cidr_block = "172.30.12.0/24"

  tags = {

    Name = "Rad-vpc"

    Owner = "RadhikaN"

    Purpose = "aws_terraform_learning"

  }

}

# CREATE PUBLIC SUBNET  

resource "aws_subnet" "public_subnet" {

vpc_id = aws_vpc.vpc_rad.id

cidr_block ="172.30.12.0/25"

map_public_ip_on_launch ="true"

availability_zone = "ap-south-1a"

tags = {

    Name = "Public SubnetRN"

}

}

# CREATE Private SUBNET 
resource "aws_subnet" "private_subnet" {

vpc_id = aws_vpc.vpc_rad.id

cidr_block ="172.30.12.128/25"

map_public_ip_on_launch ="false"

availability_zone = "ap-south-1a"

tags = {

    Name = "Private SubnetRK"

}

}

/////IGW///////////////////
resource "aws_internet_gateway" "Rad_IG" {
  vpc_id = aws_vpc.vpc_rad.id
    tags = {
    Name = "Rad_IG"
  }
}
/////////////Custom route tabel and attache it to public subnet/////
resource "aws_route_table" "pub_RT" {
  vpc_id = aws_vpc.vpc_rad.id

  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.Rad_IG.id
  }
  tags = {
    Name ="Radpub_RT"
  }
}

resource "aws_route_table_association" "AssocRTpub" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.pub_RT.id
}

/////////////Custom route tabel and attach it to private subnet/////
resource "aws_route_table" "pvt_RT" {
  vpc_id = aws_vpc.vpc_rad.id

  route {
    cidr_block = "10.0.1.0/25"
    gateway_id = aws_internet_gateway.Rad_IG.id
  }
  tags = {
    Name ="Radpvt_RT"
  }
}

resource "aws_route_table_association" "AssocRTpvt" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.pvt_RT.id
}

# data "aws_security_group" "Radhika_SG" {
#   id ="sg-0a5f3a2051699eb06"
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
# #created instance using existing security group and public subnet
resource "aws_spot_instance_request" "test_rad1" {
  ami                    = "ami-079b5e5b3971bd10d"
  # vpc_security_group_ids = [data.aws_security_group.Radhika_SG.id]
  spot_price             = "0.016"
  instance_type          = "t2.micro"
  spot_type              = "one-time"
  key_name               = "SSHKEY_Rad"
  # subnet_id              = aws_subnet.public_subnet.id
   security_groups = ["${aws_security_group.RadSG_terraform.id}"]
  subnet_id = "${aws_subnet.public_subnet.id}"

}
  
#created instance using existing security group and private subnet
resource "aws_spot_instance_request" "test_rad2" {
  ami                    = "ami-079b5e5b3971bd10d"
  # vpc_security_group_ids = [data.aws_security_group.Radhika_SG.id]
  spot_price             = "0.016"
  instance_type          = "t2.micro"
  spot_type              = "one-time"
  key_name               = "SSHKEY_Rad"
  # subnet_id                  = aws_subnet.private_subnet.id
  # security_groups        = aws_security_group.RadSG_terraform.id
    security_groups = ["${aws_security_group.RadSG_terraform.id}"]
  subnet_id = "${aws_subnet.private_subnet.id}"
}
  
