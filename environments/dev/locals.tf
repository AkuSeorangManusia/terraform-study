locals {
  name_prefix = "${var.project_name}-${var.environment}"
  common_tags = merge({
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }, var.additional_tags)

  private_workload_instance_types = {
    for name, instance_type in var.instance_types : name => instance_type if name != "edge1"
  }
}
