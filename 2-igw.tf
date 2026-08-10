resource "aws_internet_gateway" "andimsum" {
  vpc_id = aws_vpc.andimsum.id

  tags = {
    Name = "andimsum-igw"
  }
}
