module "vpc" {
  source      = "../../modules/network/vpc"
  name_prefix = local.name_prefix
  common_tags = local.common_tags
  vpc_cidr    = var.vpc_cidr
}

module "internet_gateway" {
  source      = "../../modules/network/internet_gateway"
  name_prefix = local.name_prefix
  common_tags = local.common_tags
  vpc_id      = module.vpc.id
}

module "subnets" {
  source            = "../../modules/network/subnets"
  name_prefix       = local.name_prefix
  common_tags       = local.common_tags
  vpc_id            = module.vpc.id
  subnet_cidrs      = var.subnet_cidrs
  availability_zone = var.availability_zone
}

module "public_route_table" {
  source              = "../../modules/network/public_route_table"
  name_prefix         = local.name_prefix
  common_tags         = local.common_tags
  vpc_id              = module.vpc.id
  internet_gateway_id = module.internet_gateway.id
  public_subnet_id    = module.subnets.public_id
}

module "security_groups" {
  source            = "../../modules/network/security_groups"
  name_prefix       = local.name_prefix
  common_tags       = local.common_tags
  vpc_id            = module.vpc.id
  vpc_cidr          = var.vpc_cidr
  ssh_allowed_cidrs = var.ssh_allowed_cidrs
}

module "key_pair" {
  source         = "../../modules/key_pair"
  name_prefix    = local.name_prefix
  ssh_public_key = var.ssh_public_key
}

module "ec2" {
  source                          = "../../modules/ec2"
  name_prefix                     = local.name_prefix
  common_tags                     = local.common_tags
  public_subnet_id                = module.subnets.public_id
  private_subnet_id               = module.subnets.private_id
  edge_security_group_id          = module.security_groups.edge_id
  private_security_group_id       = module.security_groups.private_id
  key_name                        = module.key_pair.name
  edge_instance_type              = var.instance_types["edge1"]
  private_workload_instance_types = local.private_workload_instance_types
}

module "private_route_table" {
  source                    = "../../modules/network/private_route_table"
  name_prefix               = local.name_prefix
  common_tags               = local.common_tags
  vpc_id                    = module.vpc.id
  private_subnet_id         = module.subnets.private_id
  edge_network_interface_id = module.ec2.edge_network_interface_id
}

resource "aws_route53_zone" "internal" {
  name = var.private_dns_zone
  vpc { vpc_id = module.vpc.id }
}

resource "aws_route53_record" "edge1" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "edge1"
  type    = "A"
  ttl     = 300
  records = [module.ec2.edge_private_ip]
}

resource "aws_route53_record" "private_workloads" {
  for_each = module.ec2.private_workload_ips
  zone_id  = aws_route53_zone.internal.zone_id
  name     = each.key
  type     = "A"
  ttl      = 300
  records  = [each.value]
}
