variable "aws_region" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "subnet_cidrs" {
  type = map(string)

  validation {
    condition     = alltrue([for subnet in ["public", "private"] : contains(keys(var.subnet_cidrs), subnet)])
    error_message = "subnet_cidrs must specify public and private ranges."
  }
}

variable "ssh_public_key_path" {
  type = string
}

variable "ssh_allowed_cidrs" {
  type = list(string)
}

variable "private_dns_zone" {
  description = "Route 53 name"
  type        = string
}

variable "instance_types" {
  type = map(string)

  validation {
    condition     = contains(keys(var.instance_types), "edge1")
    error_message = "instance_types must specify edge1."
  }
}

variable "additional_tags" {
  type    = map(string)
  default = {}
}
