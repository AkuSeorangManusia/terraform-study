resource "aws_internet_gateway" "andimsum" {
  vpc_id = aws_vpc.andimsum.id

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-igw" })
}
