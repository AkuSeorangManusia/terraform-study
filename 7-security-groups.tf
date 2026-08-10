resource "aws_security_group" "edge1" {
  name        = "andimsum-edge1"
  vpc_id      = aws_vpc.andimsum.id

  ingress {
    description = "Traffic forwarded from private workloads"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "andimsum-edge1-sg" }
}

resource "aws_security_group" "private_workloads" {
  name        = "andimsum-private-workloads"
  vpc_id      = aws_vpc.andimsum.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "andimsum-private-workloads-sg" }
}
