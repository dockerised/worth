output "vpc_cidr_block" {
  value = "${module.vpc.vpc_cidr_block}"
}
output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "private_route_table_ids"{
  value = "${module.vpc.private_route_table_ids}"
}

output "public_subnets"{
  value = "${module.vpc.public_subnets}"
}

output "node_autoscaling_group_name" {
  value = var.create_default_node_group ? module.mng-default.node_group_autoscaling_group_names[0] : null
}

output "cluster_primary_security_group_id" {
  description = "Cluster security group that was created by Amazon EKS for the cluster. Managed node groups use this security group for control-plane-to-data-plane communication. Referred to as 'Cluster security group' in the EKS console"
  value       = module.eks.cluster_primary_security_group_id
}

output "node_security_group_id" {
  value       = module.eks.node_security_group_id
}

output "database_subnets"{
  value = "${module.vpc.database_subnets}"
}

output "cluster_certificate_authority_data" {
  value = "${module.eks.cluster_certificate_authority_data}"
}
output "cluster_endpoint"{
  value = "${module.eks.cluster_endpoint}"
}