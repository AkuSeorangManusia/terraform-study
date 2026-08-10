resource "aws_route_table" "private" {
  vpc_id = aws_vpc.andimsum.id

  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = aws_instance.edge1.primary_network_interface_id
  }

  tags = {
    Name = "andimsum-private-rt"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
