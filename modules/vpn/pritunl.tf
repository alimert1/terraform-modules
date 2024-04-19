data "aws_ami" "pritunl" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20230221.0-x86_64-gp2"]
  }
}

resource "aws_instance" "pritunl" {
  ami                         = data.aws_ami.pritunl.id
  associate_public_ip_address = true
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.pritunl.key_name
  subnet_id                   = var.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.pritunl-sg.id]
  user_data                   = file("../modules/vpn/pritunl_userdata.sh")

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  tags = {
    "Name" = "Pritunl"

  }
}