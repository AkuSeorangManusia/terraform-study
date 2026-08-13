variable "name_prefix" { type = string }
variable "ssh_public_key" {
  type      = string
  sensitive = true
}
