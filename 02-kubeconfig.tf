resource "local_file" "kubernetes_config" {
  content = "${scaleway_k8s_cluster.jack.kubeconfig.0.config_file}"
  filename = "kubeconfig.yaml"
}


resource "null_resource" "kubeconfig" {
  depends_on = [scaleway_k8s_pool.prod-pool] # at least one pool here
  triggers = {
    host                   = scaleway_k8s_cluster.prod-cluster.kubeconfig[0].host
    token                  = scaleway_k8s_cluster.prod-cluster.kubeconfig[0].token
    cluster_ca_certificate = scaleway_k8s_cluster.prod-cluster.kubeconfig[0].cluster_ca_certificate
  }
}