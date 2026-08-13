variable "name_prefix" { type = string }
variable "common_tags" { type = map(string) }
variable "vpc_id" { type = string }
variable "internet_gateway_id" { type = string }
variable "public_subnet_id" { type = string }
