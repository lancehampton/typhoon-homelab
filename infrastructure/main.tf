# Typhoon Kubernetes cluster module
module "homelab" {
  source = "git::https://github.com/poseidon/typhoon//bare-metal/fedora-coreos/kubernetes?ref=v1.33.2"

  # Cluster configuration
  cluster_name           = var.cluster_name
  matchbox_http_endpoint = var.matchbox_http_endpoint
  os_stream              = var.os_stream
  os_version             = var.os_version

  # Kubernetes configuration
  k8s_domain_name    = var.k8s_domain_name
  ssh_authorized_key = var.ssh_authorized_key

  # Controller nodes
  controllers = var.controllers

  # Worker nodes
  workers = var.workers

  # Networking
  networking   = var.networking
  pod_cidr     = var.pod_cidr
  service_cidr = var.service_cidr

  # Additional configuration
  install_disk   = var.install_disk
  cached_install = var.cached_install
  kernel_args    = var.kernel_args

  # Node customization
  worker_node_labels = var.worker_node_labels
  worker_node_taints = var.worker_node_taints
  snippets           = var.snippets
}

# Save kubeconfig to local file
resource "local_file" "kubeconfig" {
  content         = module.homelab.kubeconfig-admin
  filename        = "${path.root}/kubeconfig"
  file_permission = "0600"
}

# Generate SSH key pair if not provided
resource "tls_private_key" "ssh" {
  count     = var.generate_ssh_key ? 1 : 0
  algorithm = "ED25519"
}

resource "local_file" "ssh_private_key" {
  count           = var.generate_ssh_key ? 1 : 0
  content         = tls_private_key.ssh[0].private_key_openssh
  filename        = "${path.root}/ssh_key"
  file_permission = "0600"
}

resource "local_file" "ssh_public_key" {
  count           = var.generate_ssh_key ? 1 : 0
  content         = tls_private_key.ssh[0].public_key_openssh
  filename        = "${path.root}/ssh_key.pub"
  file_permission = "0644"
}
