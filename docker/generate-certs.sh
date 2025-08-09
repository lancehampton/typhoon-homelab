#!/bin/bash

# Generate TLS certificates for Matchbox
# This script creates a Certificate Authority and server/client certificates

set -euo pipefail

CERT_DIR="../certs"
DESKTOP_IP="${DESKTOP_IP:-192.168.50.100}"

# Create certificate directory
mkdir -p ${CERT_DIR}

echo "Generating Matchbox TLS certificates for desktop IP: ${DESKTOP_IP}"

# Generate CA private key
openssl genrsa -out ${CERT_DIR}/ca.key 4096

# Generate CA certificate
openssl req -new -x509 -key ${CERT_DIR}/ca.key -sha256 \
  -subj "/C=US/ST=CA/O=Homelab/CN=Typhoon Homelab CA" \
  -days 3650 -out ${CERT_DIR}/ca.crt

# Generate server private key
openssl genrsa -out ${CERT_DIR}/server.key 4096

# Create certificate signing request
openssl req -new -key ${CERT_DIR}/server.key -out ${CERT_DIR}/server.csr \
  -subj "/C=US/ST=CA/O=Homelab/CN=matchbox"

# Create certificate extensions file
cat > ${CERT_DIR}/server.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = matchbox
DNS.2 = matchbox.home
DNS.3 = localhost
IP.1 = 127.0.0.1
IP.2 = ${DESKTOP_IP}
IP.3 = 172.20.0.2
EOF

# Generate server certificate
openssl x509 -req -in ${CERT_DIR}/server.csr -CA ${CERT_DIR}/ca.crt -CAkey ${CERT_DIR}/ca.key \
  -CAcreateserial -out ${CERT_DIR}/server.crt -days 365 -sha256 -extfile ${CERT_DIR}/server.ext

# Generate client private key
openssl genrsa -out ${CERT_DIR}/client.key 4096

# Create client certificate signing request
openssl req -new -key ${CERT_DIR}/client.key -out ${CERT_DIR}/client.csr \
  -subj "/C=US/ST=CA/O=Homelab/CN=terraform-client"

# Generate client certificate
openssl x509 -req -in ${CERT_DIR}/client.csr -CA ${CERT_DIR}/ca.crt -CAkey ${CERT_DIR}/ca.key \
  -CAcreateserial -out ${CERT_DIR}/client.crt -days 365 -sha256

# Set proper permissions
chmod 600 ${CERT_DIR}/*.key
chmod 644 ${CERT_DIR}/*.crt

echo "Certificates generated in ${CERT_DIR}/"
echo ""
echo "Next steps:"
echo "1. Start services:"
echo "   docker compose --profile dnsmasq up -d"
echo ""
echo "2. Deploy infrastructure:"
echo "   cd ../infrastructure/"
echo "   cp terraform.tfvars.example terraform.tfvars"
echo "   # Edit terraform.tfvars with your SSH key"
echo "   tofu init && tofu plan && tofu apply"
echo ""
echo "3. Access your cluster:"
echo "   export KUBECONFIG=infrastructure/kubeconfig"
echo "   kubectl get nodes"

# Clean up temporary files
rm -f ${CERT_DIR}/*.csr ${CERT_DIR}/*.ext ${CERT_DIR}/*.srl
