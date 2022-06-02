resource "scaleway_k8s_cluster" "prod-cluster" {
  name    = "prod-cluster"
  version = "1.23.4"
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
