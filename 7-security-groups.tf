resource "aws_security_group" "edge1" {
  name   = "${local.name_prefix}-edge1"
  vpc_id = aws_vpc.andimsum.id

  ingress {
    description = "Traffic forwarded from private workloads"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "Allow SSH from trusted networks"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_allowed_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-edge1-sg" })
}

resource "aws_security_group" "private_workloads" {
  name   = "${local.name_prefix}-private-workloads"
  vpc_id = aws_vpc.andimsum.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description     = "Allow SSH from aws_security_group.edge1"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.edge1.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-private-workloads-sg" })
}
