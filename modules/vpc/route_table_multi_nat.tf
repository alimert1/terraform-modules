# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.main.id
#   }

#   tags = {
#     Name      = "${lookup(var.public-subnet-map[0], "rt_name")}-RT"
#     Terraform   = "true"
#     environment = "prod"
#   }
# }

# resource "aws_route_table" "data" {
#   vpc_id = aws_vpc.main.id

#   tags = {
#     Name      = "${lookup(var.data-subnet-map[0], "rt_name")}-RT"
#     Terraform   = "true"
#     environment = "prod"

#   }
# }

# resource "aws_route_table" "private"{
#     vpc_id = aws_vpc.main.id
    
#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat.id
#   }

#   tags = {
#     Name      = "${lookup(var.private-subnet-map[0], "rt_name")}-RT"
#     Terraform   = "true"
#     environment = "prod"
#   }
# }

# resource "aws_route_table_association" "public_route_association" {
#   count          = length(var.public-subnet-map)
#   subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
#   route_table_id = aws_route_table.public.id
# }

# resource "aws_route_table_association" "data_route_association" {
#   count          = length(var.data-subnet-map)
#   subnet_id      = element(aws_subnet.data_subnets.*.id, count.index)
#   route_table_id = aws_route_table.data.id
# }

# resource "aws_route_table_association" "private_route_association" {
#   count          = length(var.private-subnet-map)
#   subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
#   route_table_id = aws_route_table.private.id
# }

##########################################3





resource "aws_route_table" "public" {
  count  = length(var.public-subnet-map)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${lookup(var.public-subnet-map[count.index], "name")}-RT"
  }
}


resource "aws_route_table" "ecs" {
  count  = length(var.ecs-subnet-map)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }

  tags = {
    Name = "${lookup(var.ecs-subnet-map[count.index], "name")}-RT"
  }
}


resource "aws_route_table" "private" {
  count  = length(var.private-subnet-map)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }

  tags = {
    Name = "${lookup(var.private-subnet-map[count.index], "name")}-RT"
  }
}


resource "aws_route_table" "data" {
  count  = length(var.data-subnet-map)
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${lookup(var.data-subnet-map[count.index], "name")}-RT"
  }
}


resource "aws_route_table_association" "public_route_association" {
  count          = length(var.public-subnet-map)
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public[count.index].id
}

resource "aws_route_table_association" "ecs_route_association" {
  count          = length(var.ecs-subnet-map)
  subnet_id      = element(aws_subnet.ecs_service_subnets.*.id, count.index)
  route_table_id = aws_route_table.ecs[count.index].id
}

resource "aws_route_table_association" "private_route_association" {
  count          = length(var.private-subnet-map)
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route_table_association" "data_route_association" {
  count          = length(var.data-subnet-map)
  subnet_id      = element(aws_subnet.data_subnets.*.id, count.index)
  route_table_id = aws_route_table.data[count.index].id
}







