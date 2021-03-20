#!/bin/sh -e

if [ ! -d '/root/.terraform.d/plugins' ]; then
  mkdir -p /root/.terraform.d/plugins
  cd /root/.terraform.d/plugins
  curl -fsSL https://github.com/hashicorp/terraform-provider-kubernetes-alpha/releases/download/0.1.0/terraform-provider-kubernetes-alpha_0.1.0_linux_amd64.zip -o terraform-provider-kubernetes-alpha.zip
  unzip terraform-provider-kubernetes-alpha.zip
  rm terraform-provider-kubernetes-alpha.zip
fi