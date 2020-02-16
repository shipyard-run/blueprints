remote_exec "setup_vault" {
  target = "container.tools"
  cmd = "/files/vault/setup_vault.sh"
}

remote_exec "nomad_jobs" {
    target = "container.tools"
    cmd = "nomad"
    args = ["run", "/files/nomad/example.nomad"]
}