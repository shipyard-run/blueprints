variable "consul_image" {
  default = "hashicorp/consul:1.11.3"
  //default = "hashicorp/consul:1.10.4"
}

variable "consul_envoy_image" {
  default     = "envoyproxy/envoy:v1.20.1"
  description = "Using the debian base images as alpine does not support arm"
  //default = "envoyproxy/envoy-alpine:v1.18.3"
}

variable "consul_and_envoy_image" {
  default = "nicholasjackson/consul-envoy:v1.11.2-v1.20.1"
}