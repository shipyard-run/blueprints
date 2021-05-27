test:
	shipyard test consul-docker/
	shipyard test consul-ingress/
	shipyard test docs
	shipyard test meshery
	shipyard test vault-k8s
	shipyard test vault-dev
	shipyard test consul-nomad
	shipyard test consul-terminating-gateways
	shipyard test consul-k8s-federated --var "consul_k8s_module=./modules/kubernetes-consul" --var "install_example_app=true"
	shipyard test modules/consul-nomad
	shipyard test modules/kubernetes-consul
	shipyard test modules/kubernetes-consul-stack
	shipyard test modules/kubernetes-monitoring
	shipyard test modules/kubernetes-smi-controller
	shipyard test modules/kubernetes-vault