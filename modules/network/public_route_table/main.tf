resource "aws_route_table" "this" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id
  }
  tags = merge(var.common_tags, { Name = "${var.name_prefix}-public-rt" })
}
resource "aws_route_table_association" "this" {
  subnet_id = var.public_subnet_id
  route_table_id = aws_route_table.this.id
}
