resource "kubernetes_secret_v1" "scaleway-access-secret" {
  metadata {
    name = "scaleway-access"
  }

  data = {
    access_key = var.scaleway_access
    secret_key = var.scaleway_secret
  }

}
