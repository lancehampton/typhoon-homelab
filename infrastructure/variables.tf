# Cluster Configuration
variable "cluster_name" {
  description = "Unique cluster name (prepended to dns_zone)"
  type        = string
  default     = "homelab"
}

variable "matchbox_http_endpoint" {
  description = "Matchbox HTTP API endpoint for asset serving (e.g. http://matchbox.example.com:8080)"
  type        = string
}

variable "matchbox_grpc_endpoint" {
  description = "Matchbox gRPC API endpoint for provider management (e.g. http://matchbox.example.com:8081)"
  type        = string
}

variable "matchbox_client_cert" {
  description = "Path to Matchbox client certificate file"
  type        = string
  default     = "~/.config/matchbox/client.crt"
}

variable "matchbox_client_key" {
  description = "Path to Matchbox client key file"
  type        = string
  default     = "~/.config/matchbox/client.key"
}

variable "matchbox_ca_cert" {
  description = "Path to Matchbox CA certificate file"
  type        = string
  default     = "~/.config/matchbox/ca.crt"
}

# Fedora CoreOS Configuration
variable "os_stream" {
  description = "Fedora CoreOS release stream (stable, testing, next)"
  type        = string
  default     = "stable"

  validation {
    condition     = contains(["stable", "testing", "next"], var.os_stream)
    error_message = "The os_stream value must be stable, testing, or next."
  }
}

variable "os_version" {
  description = "Fedora CoreOS version to PXE and install (e.g. 39.20240128.3.0)"
  type        = string
  default     = "39.20240210.3.0"
}

# Kubernetes Configuration
variable "k8s_domain_name" {
  description = "Controller DNS name which resolves to a controller instance. Workers and kubectl will communicate with this endpoint (e.g. cluster.example.com)"
  type        = string
}

variable "ssh_authorized_key" {
  description = "SSH public key for user 'core'"
  type        = string
}

variable "generate_ssh_key" {
  description = "Generate an SSH key pair for cluster access"
  type        = bool
  default     = false
}

variable "ssh_key_name" {
  description = "Base name for generated SSH key files (stored in ~/.ssh/)"
  type        = string
  default     = "typhoon-homelab-key"
}

variable "kubeconfig_filename" {
  description = "Filename for the generated kubeconfig file (stored in ~/.kube/)"
  type        = string
  default     = "config-homelab"
}

# Machine Configuration
variable "controllers" {
  description = "List of controller machine detail objects (name, mac, domain)"
  type = list(object({
    name   = string
    mac    = string
    domain = string
  }))

  validation {
    condition     = length(var.controllers) >= 1
    error_message = "At least one controller must be defined."
  }
}

variable "workers" {
  description = "List of worker machine detail objects (name, mac, domain)"
  type = list(object({
    name   = string
    mac    = string
    domain = string
  }))
  default = []
}

# Networking Configuration
variable "networking" {
  description = "Choice of networking provider (cilium or flannel)"
  type        = string
  default     = "cilium"

  validation {
    condition     = contains(["cilium", "flannel"], var.networking)
    error_message = "The networking value must be cilium or flannel."
  }
}

variable "pod_cidr" {
  description = "CIDR IPv4 range to assign to Kubernetes pods"
  type        = string
  default     = "10.20.0.0/14"
}

variable "service_cidr" {
  description = "CIDR IPv4 range to assign to Kubernetes services"
  type        = string
  default     = "10.3.0.0/16"
}

# Hardware Configuration
variable "install_disk" {
  description = "Disk device where Fedora CoreOS should be installed"
  type        = string
  default     = "sda"
}

variable "cached_install" {
  description = "PXE boot and install from the Matchbox /assets cache"
  type        = bool
  default     = false
}

variable "kernel_args" {
  description = "Additional kernel args to provide at PXE boot"
  type        = list(string)
  default     = []
}

# Node Customization
variable "worker_node_labels" {
  description = "Map from worker name to list of initial node labels"
  type        = map(list(string))
  default     = {}
}

variable "worker_node_taints" {
  description = "Map from worker name to list of initial node taints"
  type        = map(list(string))
  default     = {}
}

variable "snippets" {
  description = "Map from machine names to lists of Butane snippets"
  type        = map(list(string))
  default     = {}
}
