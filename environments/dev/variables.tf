variable "aws_region" { type = string }
variable "availability_zone" { type = string }
variable "project_name" { type = string }
variable "environment" { type = string }
variable "vpc_cidr" { type = string }
variable "subnet_cidrs" { type = map(string) }
variable "ssh_public_key" {
  type      = string
  sensitive = true
}
variable "ssh_allowed_cidrs" { type = list(string) }
variable "private_dns_zone" { type = string }
variable "instance_types" { type = map(string) }
variable "additional_tags" {
  type    = map(string)
  default = {}
}
