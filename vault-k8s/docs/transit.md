---
id: transit
title: Encryption in Transit
sidebar_label: Encryption in Transit
---

Enable the transit secrets engine

``` shell
vault secrets enable transit
```

<Terminal target="tools.container.shipyard.run" shell="/bin/bash" workdir="/files" user="root" />
<p></p>

Generate a key

```shell
vault write -f transit/keys/web
```

<Terminal target="tools.container.shipyard.run" shell="/bin/bash" workdir="/files" user="root" />
<p></p>

Encrypt some data

```shell
vault write transit/encrypt/web plaintext=$(base64 <<< "1234-1234-1234-1234")
```

<Terminal target="tools.container.shipyard.run" shell="/bin/bash" workdir="/files" user="root" />
<p></p>

Decrypt the data

```shell
vault write transit/decrypt/web ciphertext=<cypher from previous command>
```

<Terminal target="tools.container.shipyard.run" shell="/bin/bash" workdir="/files" user="root" />
<p></p>

Output is shown as base64 encoding data

```shell
echo "<value from previous command>" | base64 -d
```

<Terminal target="tools.container.shipyard.run" shell="/bin/bash" workdir="/files" user="root" />
<p></p>

Can also do this with the API

```shell
curl -s -H "X-Vault-Token: root"  http://vault-http.ingress.shipyard.run:8200/v1/transit/encrypt/web -d '{"plaintext":"MTIzNC0xMjM0LTEyMzQtMTIzNAo="}' | jq
```

<Terminal target="tools.container.shipyard.run" shell="/bin/bash" workdir="/files" user="root" />
<p></p>

Test with the API

```shell
curl -s http://web.ingress.shipyard.run:9090/pay -d '{"card_number": "1234-1234-1234-1234"}' | jq
```

<Terminal target="tools.container.shipyard.run" shell="/bin/bash" workdir="/files" user="root" />
<p></p>