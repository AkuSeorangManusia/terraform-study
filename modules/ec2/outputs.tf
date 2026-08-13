output "edge_public_ip" { value = aws_instance.edge1.public_ip }
output "edge_private_ip" { value = aws_instance.edge1.private_ip }
output "edge_network_interface_id" { value = aws_instance.edge1.primary_network_interface_id }
output "private_workload_ips" { value = { for name, instance in aws_instance.private_workloads : name => instance.private_ip } }
