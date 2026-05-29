output "certificate_authority" {
  value = module.eks_cluster.certificate_authority
}

output "endpoint" {
  value = module.eks_cluster.endpoint
}

output "cluster_name" {
  value = module.eks_cluster.cluster_name
}

output "cluster_sg" {
  value = module.eks_cluster.cluster_sg
}

output "nameservers" {
  value = module.eks_add_ons.nameservers
}

output "certificate_arn" {
  value = module.eks_add_ons.certificate_arn
}