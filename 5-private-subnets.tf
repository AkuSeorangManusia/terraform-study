resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.andimsum.id
  cidr_block              = var.private_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = false

  tags = {
    Name = "andimsum-subnet-private"
    Tier = "private"
  }
}
