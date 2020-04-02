#!/bin/bash

cd /files

if [ ! -d ./meshery ]; then
  echo "Downloading Meshery"
  git clone https://github.com/layer5io/meshery.git
fi;