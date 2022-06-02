resource "null_resource" "kubeconfig" {
  depends_on = [scaleway_k8s_pool.prod-pool] # at least one pool here
  triggers = {
    host                   = scaleway_k8s_cluster.prod-cluster.kubeconfig[0].host
    token                  = scaleway_k8s_cluster.prod-cluster.kubeconfig[0].token
    cluster_ca_certificate = scaleway_k8s_cluster.prod-cluster.kubeconfig[0].cluster_ca_certificate
  }
}

resource "scaleway_lb_ip" "nginx_ip" {
  zone       = "fr-par-1"
  project_id = scaleway_k8s_cluster.prod-cluster.project_id
}

resource "helm_release" "nginx_ingress" {
  name      = "nginx-ingress"
  namespace = "kube-system"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart = "ingress-nginx"
	create_namespace = true

  set {
	name = "controller.service.loadBalancerIP"
	value = scaleway_lb_ip.nginx_ip.ip_address
  }

  // enable proxy protocol to get client ip addr instead of loadbalancer one
  set {
	name = "controller.config.use-proxy-protocol"
	value = "true"
  }
  set {
	name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/scw-loadbalancer-proxy-protocol-v2"
	value = "true"
  }

  // indicates in which zone to create the loadbalancer
  set {
	name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/scw-loadbalancer-zone"
	value = scaleway_lb_ip.nginx_ip.zone
  }

  // enable to avoid node forwarding
  set {
	name = "controller.service.externalTrafficPolicy"
	value = "Local"
  }

  // enable this annotation to use cert-manager
  set {
	name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/scw-loadbalancer-use-hostname"
	value = "true"
  }
}