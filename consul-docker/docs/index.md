---
id: index
title: Sticky Routing
sidebar_label: Introduction
---
# Running Blueprints

There are three different way to run a blueprint

## All in one, install and run

```
curl https://shipyard.run/blueprint | bash -s github.com/shipyard-run/blueprints//consul-docker
```

## With Shipyard installed from GitHub

```
shipyard run github.com/shipyard-run/blueprints//consul-docker
```

## From a file

```
shipyard run ./consul-docker
```

If a blueprint is run from either the all in one or from GitHub, the blueprint will exist in the users home folder and can be run or modified from that location.

```
shipyard run $HOME/github.com/shipyard-run/blueprints/consul-docker
```


# Using the Terminal with Docs

Terminals embedded in docs can be expaned like:

<Terminal target="tools.container.shipyard.run" shell="/bin/bash" workdir="/files" user="root" expanded />
<p></p>

Or closed by default

<Terminal target="tools.container.shipyard.run" shell="/bin/bash" workdir="/files" user="root"/>
<p></p>

The terminal container contains the Consul CLI and the files at path /files are mounted from the blueprint ./files folder. You can copy commands and pasted direct into the terminal

```shell
consul members
```

<Terminal target="tools.container.shipyard.run" shell="/bin/bash" workdir="/files" user="root" expanded/>
<p></p>

Every container you create with Shipyard has a FQDN for example, the API container can be accessed using `<name>.<type>.shipyard.run` `api-1.container.shipyard.run`.

```shell
curl api-1.container.shipyard.run:9090
```

<Terminal target="tools.container.shipyard.run" shell="/bin/bash" workdir="/files" user="root" expanded/>
<p></p>

The embdedded terminal can target any resource in Shipyard, the target is the fully qualified name `<name>.<type>.shipyard.run`. The following example would 
create a terminal element which is running in the Consul server.

```html
<Terminal target="consul-1.container.shipyard.run" shell="/bin/sh" workdir="/config" user="root" expanded/>
```

<Terminal target="consul-1.container.shipyard.run" shell="/bin/sh" workdir="/config" user="root" expanded/>
<p></p>

# Authoring New Documentation pages

Documentation can be written as markdown, the _docs/docs folder contains the markdown files. Editing a file automatically reloads the docs in the browser.

Shipyard uses Docusaurus v2 every markdown file must have a header which contains the `title`, the unique `id`, and a label for the sidebar. The name of the file
does not need to match the `id`.

```
---
id: config
title: Configuring Consul
sidebar_label: Configuring Consul
---

My Content

<Terminal target="consul.container.shipyard" shell="/bin/sh" workdir="/config" user="root" expanded/>

## Sub heading
```

To add a new document to the sidebar edit the `sidebars.js` file and add the `id` to the array at the position you would like it to appear. For example to include a
new file with a name `config`:

```js
module.exports = {
    docs: {
      Consul: ['index', 'config'],
    },
  };
```

# Configuring Consul

The configuration for the Consul server is at the path `/consul_config/consul.hcl`, this file mirrored from the local machine to `/config` in the container where it is loaded.
To bootstrap the server adding central config, modify the `config_entries` stanza in this file.

```json
config_entries {
  # We are using gateways and L7 config set the 
  # default protocol to HTTP
  bootstrap 
    {
      kind = "proxy-defaults"
      name = "global"

      config {
        protocol = "http"
      }

      mesh_gateway = {
        mode = "local"
      }
    }
}
```