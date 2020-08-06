path "transit/verify/hashicoin/sha2-256" {
    capabilities = ["update"]
}

path "/transit/verify/:name/sha1" {
    capabilities = ["deny"]
}