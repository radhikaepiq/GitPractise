resource "aws_vpc" "rad-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = merge(
      var.resource_tags,
{
    Name = var.vpc_name
    }
  )
}