# Typhoon Homelab

A single-node Kubernetes homelab built with [Typhoon](https://typhoon.psdn.io/) using Fedora CoreOS, Matchbox for PXE provisioning, and infrastructure as code.

## Overview

This project implements a single-node bare-metal Kubernetes cluster using:

- **Typhoon** - Minimal, free Kubernetes distribution
- **Fedora CoreOS** - Container-optimized operating system
- **Matchbox** - Network boot and machine provisioning service
- **OpenTofu/Terraform** - Infrastructure as code
- **Ignition** - Declarative system configuration
- **Cilium or Flannel** - Container networking (Cilium default for eBPF benefits)

## Architecture

```mermaid
graph TB
    subgraph "Development Machine (macOS)"
        DEV["`**Development Tools**
        • OpenTofu/Terraform
        • kubectl
        • SSH client
        • Git/VSCode`"]
    end

    subgraph "Desktop PC (Linux)"
        MATCHBOX["`**Matchbox Container**
        • PXE boot service
        • Profile management
        • Asset serving`"]
        TFTP["`**TFTP Container**
        • iPXE binaries
        • Boot configuration`"]
    end

    subgraph "Target Hardware"
        NODE["`**Single Node**
        • Fedora CoreOS
        • Kubernetes control plane
        • Schedulable for workloads
        • etcd + kubelet + kube-proxy`"]
    end

    subgraph "Home Network"
        ROUTER["`**Router/DHCP**
        • PXE boot forwarding
        • DNS resolution
        • Network connectivity`"]
    end

    DEV -.->|SSH/kubectl| NODE
    DEV -.->|API calls| MATCHBOX
    MATCHBOX -->|HTTP/gRPC| NODE
    TFTP -->|PXE boot| NODE
    ROUTER -->|DHCP/PXE| NODE
    ROUTER -.->|Network| MATCHBOX
    ROUTER -.->|Network| TFTP
```

## Key Features

- **Single-Node Design**: Controller node is schedulable for workloads, perfect for homelab environments
- **Docker-Based Services**: Matchbox and TFTP run in containers on your desktop PC
- **Manual Control**: No hidden automation - understand each step before proceeding
- **Production Patterns**: Uses official Typhoon modules and Fedora CoreOS best practices
- **Expansion Ready**: Easy path to add worker nodes when needed

## Networking Choice: Cilium vs Flannel

Typhoon supports both Cilium and Flannel CNI providers. This project defaults to **Cilium** for several reasons:

### Cilium (Default)
- **eBPF-based**: More efficient networking with lower CPU overhead
- **Network Policies**: Built-in security policies for pod-to-pod communication
- **Observability**: Better network visibility and monitoring capabilities
- **Single-node Optimized**: Better resource utilization for constrained environments
- **Future-proof**: Modern networking stack with ongoing development

### Flannel (Alternative)
- **Simplicity**: Easier to understand and troubleshoot
- **Lightweight**: Minimal resource footprint
- **Mature**: Well-tested, stable, widely deployed
- **Learning-friendly**: Simpler concepts for networking beginners

To use Flannel instead, change the `networking` variable in `terraform.tfvars`:
```hcl
networking = "flannel"
```

## Prerequisites

### Hardware Requirements
- **Development Machine**: macOS/Linux with OpenTofu/Terraform, kubectl, SSH
- **Desktop PC**: Linux machine with Docker for running Matchbox services
- **Target Node**: Single bare-metal server with 2GB+ RAM, 30GB+ disk, PXE-enabled NIC
- **Network**: Home router with DHCP and PXE boot capability

### Software Requirements
- **Docker** and Docker Compose on desktop PC
- **OpenTofu** or Terraform v1.0+ on development machine
- **kubectl** for cluster management
- **SSH keys** for machine access

## Quick Start

1. **Deploy Matchbox Service on Desktop PC**
   ```bash
   cd docker/
   cp .env.example .env
   # Edit .env with your network settings
   ./generate-certs.sh
   docker-compose up -d
   ```

2. **Configure Infrastructure on Dev Machine**
   ```bash
   cd infrastructure/
   cp terraform.tfvars.example terraform.tfvars
   # Edit with your environment details
   ```

3. **Deploy Single-Node Cluster**
   ```bash
   tofu init
   tofu plan
   tofu apply
   ```

4. **Power On Target Node with PXE Boot**
   ```bash
   # Set boot device to PXE and power on (manual or IPMI)
   ipmitool -H node1.home -U USER -P PASS chassis bootdev pxe
   ipmitool -H node1.home -U USER -P PASS power on
   ```

5. **Wait for Bootstrap and Verify Cluster**
   ```bash
   export KUBECONFIG=infrastructure/kubeconfig
   kubectl get nodes
   kubectl get pods -A
   # Take time to manually inspect and understand your single-node cluster
   ```

## Directory Structure

```
├── README.md                    # This file
├── .gitignore                   # Git ignore patterns
├── certs/                       # TLS certificates (generated)
├── docker/                      # Docker Compose for Matchbox/dnsmasq
│   ├── docker-compose.yml       # Service definitions
│   ├── generate-certs.sh        # Certificate generation
│   └── .env.example             # Environment configuration
└── infrastructure/              # Terraform/OpenTofu configs
    ├── main.tf                  # Main cluster configuration
    ├── providers.tf             # Terraform providers and versions
    ├── variables.tf             # Variable definitions
    ├── outputs.tf               # Output values
    └── terraform.tfvars.example # Example configuration
```

## License

MIT License - see [LICENSE](LICENSE) file for details.

## References

- [Typhoon Documentation](https://typhoon.psdn.io/)
- [Fedora CoreOS](https://fedoraproject.org/coreos/)
- [Matchbox Project](https://github.com/poseidon/matchbox)
- [Ignition Specification](https://coreos.github.io/ignition/)
