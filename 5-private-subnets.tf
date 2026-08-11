resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.andimsum.id
  cidr_block              = var.subnet_cidrs["private"]
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-subnet-private"
    Tier = "private"
  })
}
