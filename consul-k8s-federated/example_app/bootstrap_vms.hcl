template "bootstrap_agent" {
  source = <<-EOF
  #!/bin/sh -e

  # Create the ACL policy and Token for the Payments service
  cat <<-EOT > /tmp/currency-agent-policy.hcl
  node_prefix "" {
     policy = "write"
  }
  service_prefix "" {
     policy = "read"
  }
  service_prefix "currency" {
     policy = "write"
  }
  EOT

  consul acl policy create \
    -name "currency-agent-token" \
    -description "Currency Agent Token Policy" \
    -rules @/tmp/currency-agent-policy.hcl

  consul acl token create -description "Currency Agent Token" \
    -policy-name "currency-agent-token" \
    -format json | jq -r '.SecretID' > /files/currency-agent.token
  
  export CURRENCY_AGENT_TOKEN="$(cat /files/currency-agent.token)"

  cat <<-EOT >> /files/currency-token-config.hcl
  acl {
    tokens {
      default = "$${CURRENCY_AGENT_TOKEN}"
    }
  }
  EOT
  
  # Create the ACL policy and Token for the Web service
  cat <<-EOT > /tmp/web-agent-policy.hcl
  node_prefix "" {
     policy = "write"
  }
  service_prefix "" {
     policy = "read"
  }
  service_prefix "web" {
     policy = "write"
  }
  EOT
  
  consul acl policy create \
    -name "web-agent-token" \
    -description "Web Agent Token Policy" \
    -rules @/tmp/web-agent-policy.hcl

  consul acl token create -description "Web Agent Token" \
    -policy-name "web-agent-token" \
    -format json | jq -r '.SecretID' > /files/web-agent.token

  export WEB_AGENT_TOKEN="$(cat /files/web-agent.token)"
  
  cat <<-EOT >> /files/web-token-config.hcl
  acl {
    tokens {
      default = "$${WEB_AGENT_TOKEN}"
    }
  }
  EOT
  
  EOF

  destination = "${data("agent_config")}/agent_bootstrap.sh"
}

exec_remote "agent_consul_bootstrap" {
  depends_on = ["module.vms"]
  target     = "container.1-consul-server"

  cmd = "sh"
  args = [
    "/files/agent_bootstrap.sh"
  ]
}
