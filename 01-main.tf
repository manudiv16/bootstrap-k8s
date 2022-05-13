resource "scaleway_k8s_cluster" "jack" {
  name    = "jack"
  version = "1.23.4"
  cni     = "calico"
}
resource "scaleway_k8s_pool" "john" {
  cluster_id = scaleway_k8s_cluster.jack.id
  name       = "john"
  node_type  = "DEV1-M"
  size       = 1
}
