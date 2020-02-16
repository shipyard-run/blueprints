exec_remote "nomad_jobs" {
    depends_on = ["nomad_cluster.nomad"]
    target = "container.tools"

    network {
        name = "network.cloud"
    }

    cmd = "nomad"
    args = ["run", "/files/nomad/example.nomad"]
}