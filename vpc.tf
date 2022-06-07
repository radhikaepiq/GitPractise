resource "aws_vpc" "main" {
  cidr_block       = "172.30.12.0/24"
  instance_tenancy = "default"
  tags = {
    Name = "VPC-demo_rad"
    Purpose = "terrafrom using Jenkins"
  }
}