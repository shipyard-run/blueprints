#!/bin/bash
git clone https://github.com/develeap/efk-stack.git
cd efk-stack
./install.sh -n logging -p myefkpwd -x elasticsearch.resources.limits.memory=0.5Gi -x elasticsearch.resources.limits.cpu=300m -x elasticsearch.master.volume.size=1Gi -x elasticsearch.data.volume.size=1Gi -x elasticsearch.data.volume.storageClass=local-path -x elasticsearch.master.volume.storageClass=local-path

if [ $? -eq 0 ]; then
    exit 0 # success
else
    exit 1 # failure
fi