variable "name_prefix" { type = string }
variable "common_tags" { type = map(string) }
variable "vpc_id" { type = string }
variable "vpc_cidr" { type = string }
variable "ssh_allowed_cidrs" { type = list(string) }
