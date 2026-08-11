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
  key_name   = "${local.name_prefix}-key"
  public_key = file(var.ssh_public_key_path)
}

resource "aws_instance" "edge1" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = var.instance_types[local.edge_host_name]
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

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-ec2-${local.edge_host_name}"
    Role = "edge"
  })
}

resource "aws_instance" "private_workloads" {
  for_each = local.private_workload_instance_types

  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = each.value
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.private_workloads.id]
  key_name               = aws_key_pair.andimsum.key_name

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-ec2-${each.key}"
    Role = each.key
  })
}
