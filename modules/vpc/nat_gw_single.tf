resource "aws_eip" "eip" {
  domain = "vpc"

  tags = {
    Name      = "${var.env}-NATGW-eip"
    Terraform   = "true"
    environment = "Prod"
  }
}


resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name      = "${var.env}-NATGW"
    Terraform   = "true"
    environment = "Prod"
  }
}