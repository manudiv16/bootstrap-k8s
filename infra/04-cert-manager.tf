resource "helm_release" "cert-manager-release" {
  name             = "cert-manager-release"
  namespace        = "cert-manager"
  create_namespace = true
  chart            = "cert-manager"
  repository       = "https://charts.jetstack.io"
  version          = "v1.8.1"

  set {
    name  = "installCRDs"
    value = "true"
  }
}
