output "edge1_public_ip" { value = module.ec2.edge_public_ip }
output "private_host_ips" { value = module.ec2.private_workload_ips }
output "private_dns_zone" { value = aws_route53_zone.internal.name }
