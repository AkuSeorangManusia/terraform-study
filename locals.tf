locals {
  # name_prefix = "${var.project_name}-${var.environment}"
  name_prefix = var.project_name

  common_tags = merge(
    {
      Project   = var.project_name
      ManagedBy = "Terraform"
    },
    # var.additional_tags,
  )

  edge_host_name = "edge1"

  private_workload_instance_types = {
    for host_name, instance_type in var.instance_types : host_name => instance_type
    if host_name != local.edge_host_name
  }
}
