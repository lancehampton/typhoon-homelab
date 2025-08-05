# Cluster outputs
output "kubeconfig_admin" {
  description = "Generated kubeconfig for cluster admin"
  value       = module.homelab.kubeconfig-admin
  sensitive   = true
}

output "kubeconfig_path" {
  description = "Path to the generated kubeconfig file"
  value       = local_file.kubeconfig.filename
}

# Cluster information
output "cluster_name" {
  description = "Name of the Kubernetes cluster"
  value       = var.cluster_name
}

output "k8s_domain_name" {
  description = "Kubernetes API server domain name"
  value       = var.k8s_domain_name
}

# Node information
output "controllers" {
  description = "Controller node configurations"
  value = {
    for controller in var.controllers : controller.name => {
      mac    = controller.mac
      domain = controller.domain
    }
  }
}

output "workers" {
  description = "Worker node configurations"
  value = {
    for worker in var.workers : worker.name => {
      mac    = worker.mac
      domain = worker.domain
    }
  }
}

# Network configuration
output "networking" {
  description = "Networking provider used"
  value       = var.networking
}

output "pod_cidr" {
  description = "CIDR range for pods"
  value       = var.pod_cidr
}

output "service_cidr" {
  description = "CIDR range for services"
  value       = var.service_cidr
}

# SSH key information (if generated)
output "ssh_private_key_path" {
  description = "Path to generated SSH private key"
  value       = var.generate_ssh_key ? local_file.ssh_private_key[0].filename : null
}

output "ssh_public_key_path" {
  description = "Path to generated SSH public key"
  value       = var.generate_ssh_key ? local_file.ssh_public_key[0].filename : null
}

output "ssh_public_key" {
  description = "Generated SSH public key content"
  value       = var.generate_ssh_key ? tls_private_key.ssh[0].public_key_openssh : null
}
