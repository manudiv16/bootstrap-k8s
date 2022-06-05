resource "local_file" "kubernetes_config" {
  content = "${scaleway_k8s_cluster.prod-cluster.kubeconfig.0.config_file}"
  filename = "kubeconfig.yaml"
}

