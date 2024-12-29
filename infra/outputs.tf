output "cluster_id" {
  description = "EKS Cluster name"
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "EKS API Endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "Cluster CA data"
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true
}

output "kubeconfig" {
  description = "Kubeconfig from template"
  value       = local.kubeconfig_content
  sensitive   = true
}
