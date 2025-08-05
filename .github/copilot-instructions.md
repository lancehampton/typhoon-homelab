<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

# Copilot Instructions for Typhoon Homelab

## Project Context
This is a Typhoon-based Kubernetes homelab project that uses:
- **Typhoon** for minimal Kubernetes distribution
- **Fedora CoreOS** as the host operating system
- **Matchbox** for PXE network boot provisioning
- **OpenTofu/Terraform** for infrastructure as code
- **Ignition** for declarative system configuration
- **Bare-metal deployment** patterns

## Code Style and Conventions

### Terraform/OpenTofu
- Use HCL2 syntax with proper formatting
- Follow Typhoon module patterns and variable naming
- Include comprehensive variable descriptions and validation
- Use consistent resource naming: `cluster_name-resource_type-identifier`
- Always specify provider versions in versions.tf

### Ignition/Butane Configs
- Use Butane YAML format for human readability
- Follow Fedora CoreOS best practices for systemd units
- Include comprehensive comments explaining configurations
- Use consistent file paths following FHS standards
- Validate configurations before deployment

### Documentation
- Maintain accurate README files in each directory
- Include prerequisites, setup steps, and troubleshooting
- Use clear architecture diagrams where helpful
- Document network requirements and port mappings
- Provide example configurations with explanations

## Infrastructure Patterns
- Follow Typhoon's official bare-metal patterns
- Use modular Terraform configurations
- Implement proper secret management practices
- Include disaster recovery and backup strategies
- Design for high availability where applicable

## Security Considerations
- Always use TLS for Matchbox API communications
- Implement proper RBAC for Kubernetes
- Use secure defaults for all configurations
- Document security implications of configuration choices
- Follow principle of least privilege

## Deployment Practices
- Test configurations in staging before production
- Use GitOps workflows for configuration management
- Implement proper change management processes
- Document rollback procedures
- Monitor and log all infrastructure changes
- Start with single-node clusters before scaling to multi-node
- Use Docker containers for supporting services during development

## Single-Node Cluster Guidelines
- Configure controller nodes to be schedulable (remove NoSchedule taint)
- Use minimal resource requirements for development
- Plan for easy expansion to multi-node later
- Document the upgrade path from single to multi-node

## Container Deployment for Supporting Services
- Use Docker Compose for orchestrating supporting services
- Run Matchbox and PXE services in containers on dedicated hardware
- Separate supporting services from target cluster nodes
- Use persistent volumes for configuration and data
- Document container networking and port requirements

## Best Practice Sources
- Always reference official [Typhoon documentation](https://typhoon.psdn.io/) first
- Follow [Fedora CoreOS Config Spec](https://coreos.github.io/butane/config-spec/) for Ignition
- Use [Matchbox API documentation](https://matchbox.psdn.io/api/) for integration
- Reference [Kubernetes single-node patterns](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#control-plane-node-isolation) for scheduling
- Follow [Docker best practices](https://docs.docker.com/develop/dev-best-practices/) for container deployment

## References
- Follow [Typhoon documentation](https://typhoon.psdn.io/) patterns
- Reference [Fedora CoreOS](https://docs.fedoraproject.org/en-US/fedora-coreos/) best practices
- Use [Matchbox](https://matchbox.psdn.io/) official examples
- Adhere to [Kubernetes](https://kubernetes.io/docs/) standards
- Follow [Butane specification](https://coreos.github.io/butane/) for readable configs
