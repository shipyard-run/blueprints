---
id: static
title: Static secrets 
sidebar_label: Static secrets
---

Writing static secrets

```
vault kv put secret/web payments_api_key=abcdefg
```

<Terminal target="tools.container.shipyard.run" shell="/bin/bash" workdir="/files" user="root" />
<p></p>

Reading static secrets

```
vault kv get secret/web
```

<Terminal target="tools.container.shipyard.run" shell="/bin/bash" workdir="/files" user="root" />
<p></p>