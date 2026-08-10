variable "aws_region" {
  type    = string
  default = "ap-southeast-3"
}

variable "availability_zone" {
  type    = string
  default = "ap-southeast-3a"
}

variable "vpc_cidr" {
  type    = string
  default = "10.20.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.20.1.0/24"
}

variable "private_subnet_cidr" {
  type    = string
  default = "10.20.2.0/24"
}

variable "instance_types" {
  type        = map(string)
  default = {
    edge1 = "t3.micro"
    f1    = "t3.micro"
    m1    = "t3.micro"
    ci1   = "t3.small"
    mon1  = "t3.small"
  }

  validation {
    condition     = alltrue([for host in ["edge1", "f1", "m1", "ci1", "mon1"] : contains(keys(var.instance_types), host)])
    error_message = "instance_types must specify edge1, f1, m1, ci1, and mon1."
  }
}

variable "key_file_path" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}
