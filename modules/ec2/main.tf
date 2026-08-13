data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["al2023-ami-*-x86_64"]
  }
  filter {
    name = "state"
    values = ["available"]
  }
}

resource "aws_instance" "edge1" {
  ami = data.aws_ami.amazon_linux_2023.id
  instance_type = var.edge_instance_type
  subnet_id = var.public_subnet_id
  vpc_security_group_ids = [var.edge_security_group_id]
  associate_public_ip_address = true
  source_dest_check = false
  key_name = var.key_name
  user_data = <<-EOF
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
  tags = merge(var.common_tags, { Name = "${var.name_prefix}-ec2-edge1", Role = "edge" })
}

resource "aws_instance" "private_workloads" {
  for_each = var.private_workload_instance_types
  ami = data.aws_ami.amazon_linux_2023.id
  instance_type = each.value
  subnet_id = var.private_subnet_id
  vpc_security_group_ids = [var.private_security_group_id]
  key_name = var.key_name
  tags = merge(var.common_tags, { Name = "${var.name_prefix}-ec2-${each.key}", Role = each.key })
}
