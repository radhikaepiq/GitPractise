resource "aws_spot_instance_request" "test_rad" {
  ami                    = "ami-079b5e5b3971bd10d"
  spot_price             = "0.016"
  instance_type          = "t2.micro"
  spot_type              = "one-time"
  key_name               = "SSHKEY_Rad"
tags = {
    Name = "radspotinst"
  }
}