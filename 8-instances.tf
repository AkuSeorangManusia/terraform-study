data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_key_pair" "andimsum" {
  key_name   = "andimsum-key"
  public_key = file(pathexpand(var.key_file_path))
}

resource "aws_instance" "edge1" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = var.instance_types["edge1"]
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.edge1.id]
  associate_public_ip_address = true
  source_dest_check           = false
  key_name                    = aws_key_pair.andimsum.key_name
  user_data                   = <<-EOF
    #!/bin/bash
    set -euxo pipefail
    dnf install -y iptables-services
    sysctl -w net.ipv4.ip_forward=1
    echo 'net.ipv4.ip_forward = 1' > /etc/sysctl.d/99-nat-forwarding.conf
    iptables -t nat -A POSTROUTING -o ens5 -j MASQUERADE
    iptables -A FORWARD -i ens5 -o ens5 -j ACCEPT
    service iptables save
    systemctl enable iptables
  EOF

  tags = { 
    Name = "ec2-edge1" 
    Role = "edge"
  }
}

resource "aws_instance" "private_workloads" {
  for_each = toset(["mon1", "ci1", "f1", "m1"])

  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_types[each.key]
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.private_workloads.id]
  key_name               = aws_key_pair.andimsum.key_name

  tags = {
    Name = "ec2-${each.key}"
    Role = each.key
  }
}
