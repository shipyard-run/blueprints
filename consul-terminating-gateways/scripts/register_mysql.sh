#!/bin/sh

until curl -s -k ${CONSUL_HTTP_ADDR}/v1/status/leader | grep 8300; do
  echo "Waiting for Consul to start"
  sleep 1
done

curl -XPUT -d @/config/mysql_svc.json ${CONSUL_HTTP_ADDR}/v1/catalog/register