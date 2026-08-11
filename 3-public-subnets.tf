resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.andimsum.id
  cidr_block              = var.subnet_cidrs["public"]
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-subnet-public"
    Tier = "public"
  })
}