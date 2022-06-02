terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
      version = "2.2.1"
    }
    helm = {
      source = "hashicorp/helm",
      version = "v2.5.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.11.0"
    }
  }
  required_version = ">= 0.13"
}

provider "kubernetes" {
  # Configuration options
}
provider "scaleway" {
  access_key = var.access_key
  secret_key = var.secret_key
  project_id = var.project_id
  region     = var.region
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

provider "kubernetes" {
  load_config_file = "false"

  host  = null_resource.kubeconfig.triggers.host
  token = null_resource.kubeconfig.triggers.token
  cluster_ca_certificate = base64decode(
  null_resource.kubeconfig.triggers.cluster_ca_certificate
  )
}