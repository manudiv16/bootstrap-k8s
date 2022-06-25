resource "helm_release" "external-dns" {
  name = "external-dns"
  depends_on = [
    kubernetes_secret_v1.scaleway-access-secret,
  ]
  repository = "https://kubernetes-sigs.github.io/external-dns"
  chart      = "external-dns"
  namespace  = "default"

  values = [
    file("charts/external-dns.yaml")
  ]

  set {
    name  = "provider"
    value = "scaleway"
  }

}

