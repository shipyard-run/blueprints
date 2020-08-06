path "transit/sign/hashicoin" {
    capabilities = ["update"]
}

# sha1 should be considered a compromised algorithm.
path "/transit/sign/hashicoin/sha1" {
    capabilities = ["deny"]
}