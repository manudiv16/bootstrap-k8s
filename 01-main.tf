resource "scaleway_k8s_cluster" "prod-cluster" {
  name    = "prod-cluster"
  version = "1.23.6"
  cni     = "calico"
    autoscaler_config {
    disable_scale_down              = false
    scale_down_delay_after_add      = "5m"
    estimator                       = "binpacking"
    expander                        = "random"
    ignore_daemonsets_utilization   = true
    balance_similar_node_groups     = true
    expendable_pods_priority_cutoff = -5
  }
}
resource "scaleway_k8s_pool" "prod-pool" {
  cluster_id = scaleway_k8s_cluster.prod-cluster.id
  name       = "prod-pool"
  node_type  = "DEV1-M"
  size       = 1
  autoscaling = true
  autohealing = true
  min_size    = 1
  max_size    = 2
}

resource "null_resource" "kubeconfig" {
  depends_on = [scaleway_k8s_pool.prod-pool] # at least one pool here
  triggers = {
    host                   = scaleway_k8s_cluster.prod-cluster.kubeconfig[0].host
    token                  = scaleway_k8s_cluster.prod-cluster.kubeconfig[0].token
    cluster_ca_certificate = scaleway_k8s_cluster.prod-cluster.kubeconfig[0].cluster_ca_certificate
  }
}

provider "helm" {
  kubernetes {
    host = null_resource.kubeconfig.triggers.host
    token = null_resource.kubeconfig.triggers.token
    cluster_ca_certificate = base64decode(
    null_resource.kubeconfig.triggers.cluster_ca_certificate
    )
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

  set {
    name = "controller.service.loadBalancerIP"
    value = scaleway_lb_ip.nginx_ip.ip_address
  }

  set {
    name = "controller.config.use-proxy-protocol"
    value = "true"
  }
  set {
    name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/scw-loadbalancer-proxy-protocol-v2"
    value = "true"
  }

  set {
    name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/scw-loadbalancer-zone"
    value = scaleway_lb_ip.nginx_ip.zone
  }

  set {
    name = "controller.service.externalTrafficPolicy"
    value = "Local"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/scw-loadbalancer-use-hostname"
    value = "true"
  }
}