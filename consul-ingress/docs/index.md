---
id: index
title: Ingress Gateways
sidebar_label: Ingress
---
# Application infrastructure

The currently running application has the following components.

![](https://raw.githubusercontent.com/shipyard-run/blueprints/master/consul-ingress/docs/images/infa.png)

# Write the config

Before using ingress gateways you need to configure them,  

```javascript
Kind = "ingress-gateway"
Name = "ingress-service"

TLS {
  Enabled = true
}

Listeners = [
  {
    Port = 443
    Protocol = "http"
    Services = [
      {
        Name = "api"
        Hosts = ["api.ingress.container.shipyard.run"]
      },
      {
        Name = "web"
        Hosts = ["web.ingress.container.shipyard.run"]
      }
    ]
  }
]
```

```
consul config write ./ingress.hcl
```

<p>
  <Terminal target="consul.container.shipyard.run" shell="sh" workdir="/files" user="root" expanded />
</p>

# Fetch root cert

```
curl -s http://127.0.0.1:8500/v1/connect/ca/roots | jq -r '.Roots[0].RootCert' > root.cert
```

<p>
  <Terminal target="consul.container.shipyard.run" shell="sh" workdir="/files" user="root" expanded />
</p>


# Show client certificate for gateway

```shell
echo | openssl s_client -showcerts -servername web.ingress.container.shipyard.run -connect web.ingress.container.shipyard.run 2>/dev/null | openssl x509 -inform pem -noout -text  
```

```shell
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 12 (0xc)
        Signature Algorithm: ecdsa-with-SHA256
        Issuer: CN = pri-1hw6eku.consul.ca.b1eddb34.consul
        Validity
            Not Before: Jun  7 10:01:57 2020 GMT
            Not After : Jun 10 10:01:57 2020 GMT
        Subject: CN = ingressservice.svc.default.b1eddb34.consul
        Subject Public Key Info:
            Public Key Algorithm: id-ecPublicKey
                Public-Key: (256 bit)
                pub:
                    04:e2:7f:4b:d6:a0:d9:de:c7:4f:9f:09:2f:7a:22:
                    60:2a:ce:2c:c5:ba:88:11:8a:66:9f:80:50:7f:40:
                    52:1c:0f:15:de:23:fc:03:38:41:47:6b:8f:0c:47:
                    d4:ba:e0:28:c7:62:30:1a:ce:79:96:f4:27:52:81:
                    12:43:1e:37:72
                ASN1 OID: prime256v1
                NIST CURVE: P-256
        X509v3 extensions:
            X509v3 Key Usage: critical
                Digital Signature, Key Encipherment, Data Encipherment, Key Agreement
            X509v3 Extended Key Usage: 
                TLS Web Client Authentication, TLS Web Server Authentication
            X509v3 Basic Constraints: critical
                CA:FALSE
            X509v3 Subject Key Identifier: 
                49:C2:3C:B4:B6:75:3A:5F:6F:5D:4A:DC:68:B8:14:37:2D:65:62:86:9D:0F:28:06:4D:C1:BF:CD:AB:E2:E8:A0
            X509v3 Authority Key Identifier: 
                keyid:07:19:20:58:4C:D2:2A:89:5B:00:72:F5:45:2D:6B:56:BB:64:F1:AF:DF:81:6F:81:89:3F:AA:1F:4C:2B:8A:60

            X509v3 Subject Alternative Name: 
                DNS:*.ingress.consul., DNS:*.ingress.dc1.consul., DNS:api.ingress.container.shipyard.run, DNS:web.ingress.container.shipyard.run, URI:spiffe://b1eddb34-f2af-f8ab-bd64-bc44fb9d4392.consul/ns/default/dc/dc1/svc/ingress-service
    Signature Algorithm: ecdsa-with-SHA256
         30:45:02:21:00:fd:22:d1:86:6c:cd:e3:9b:c4:34:d5:ab:4b:
         1f:79:90:3f:be:72:27:96:03:34:06:01:ce:d5:b0:42:e5:7d:
         18:02:20:04:49:4d:94:e7:8b:df:5c:cc:c5:b4:d6:2a:24:fa:
         22:d2:28:ba:a2:d2:46:a9:bd:1d:64:9c:e5:75:7d:57:1f
```

# Call gateway using root from consul

```
curl -v --cacert ./root.cert  https://web.ingress.container.shipyard.run
```

<p>
  <Terminal target="consul.container.shipyard.run" shell="sh" workdir="/files" user="root" expanded />
</p>