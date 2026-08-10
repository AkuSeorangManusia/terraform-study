resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.andimsum.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "andimsum-subnet-public"
    Tier = "public"
  }
}
