terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
      version = "2.2.1"
    }
  }
  required_version = ">= 0.13"
}

provider "scaleway" {
  access_key = var.access_key
  secret_key = var.secret_key
  project_id = var.project_id
  region     = var.region
}

