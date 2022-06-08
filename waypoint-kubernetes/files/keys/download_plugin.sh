# Determine the OS and architecure
ARCH=$(uname -m)
SHIPYARD_ARCH="amd64"

if [ "${ARCH}" == "x86_64" ]; then
  SHIPYARD_ARCH="amd64"
fi

if [ "${ARCH}" == "arm64" ]; then
  SHIPYARD_ARCH="arm64"
fi

wget --no-check-certificate https://github.com/hashicorp-dev-advocates/waypoint-plugin-noop/releases/download/v0.2.2/waypoint-plugin-noop_linux_${SHIPYARD_ARCH}.zip && \
  unzip waypoint-plugin-noop_linux_amd64.zip