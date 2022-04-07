job "minecraft" {
    datacenters = ["dc1"]

    group "minecraft" {
        count = 1
        
        task "server" {
            driver = "java"

            template {
                destination = "eula.txt"
                data = <<EOF
eula=true
EOF
            }

            artifact {
                source = "https://launcher.mojang.com/v1/objects/bb2b6b1aefcd70dfd1892149ac3a215f6c636b07/server.jar"
            }

            config {
                jar_path = "local/server.jar"
                args = ["nogui"]
                jvm_options = ["-Xmx2048m", "-Xms256m"]
            }

            resources {
                cpu = 100
                memory = 2048
            }
        }
    }
}
