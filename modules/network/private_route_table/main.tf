resource "aws_route_table" "this" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    network_interface_id = var.edge_network_interface_id
  }
  tags = merge(var.common_tags, { Name = "${var.name_prefix}-private-rt" })
}
resource "aws_route_table_association" "this" {
  subnet_id = var.private_subnet_id
  route_table_id = aws_route_table.this.id
}
