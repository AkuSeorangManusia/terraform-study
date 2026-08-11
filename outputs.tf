output "edge1_public_ip" {
  value = aws_instance.edge1.public_ip
}

output "private_host_ips" {
  value = {
    for name, instance in aws_instance.private_workloads : name => instance.private_ip
  }
}

output "private_dns_zone" {
  value = aws_route53_zone.internal.name
}
