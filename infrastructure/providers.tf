terraform {
  required_version = ">= 1.0"
  required_providers {
    ct = {
      source  = "poseidon/ct"
      version = "~> 0.13.0"
    }
    matchbox = {
      source  = "poseidon/matchbox"
      version = "~> 0.5.2"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "matchbox" {
  endpoint    = var.matchbox_grpc_endpoint
  client_cert = file(var.matchbox_client_cert)
  client_key  = file(var.matchbox_client_key)
  ca          = file(var.matchbox_ca_cert)
}

provider "ct" {}
