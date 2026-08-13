variable "name_prefix" { type = string }
variable "common_tags" { type = map(string) }
variable "vpc_id" { type = string }
variable "private_subnet_id" { type = string }
variable "edge_network_interface_id" { type = string }
