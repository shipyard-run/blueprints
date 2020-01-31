remote_exec "nomad_jobs" {
    target = "container.tools"
    cmd = "nomad"
    args = ["run", "/files/nomad/example.nomad"]
}