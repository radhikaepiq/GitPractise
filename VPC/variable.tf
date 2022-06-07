

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "VPC-demo_rad"
    Purpose = "terrafrom using Jenkins"
  }
}