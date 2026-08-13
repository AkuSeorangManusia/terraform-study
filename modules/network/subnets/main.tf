resource "aws_subnet" "public" {
  vpc_id = var.vpc_id
  cidr_block = var.subnet_cidrs["public"]
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true
  tags = merge(var.common_tags, { Name = "${var.name_prefix}-subnet-public", Tier = "public" })
}

resource "aws_subnet" "private" {
  vpc_id = var.vpc_id
  cidr_block = var.subnet_cidrs["private"]
  availability_zone = var.availability_zone
  map_public_ip_on_launch = false
  tags = merge(var.common_tags, { Name = "${var.name_prefix}-subnet-private", Tier = "private" })
}
