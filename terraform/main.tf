terraform {
  required_version = ">= 1.0"
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }

    elasticstack = {
      source  = "elastic/elasticstack"
      version = "~>0.11"
    }

    ec = {
      source  = "elastic/ec"
      version = "~> 0.9.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "ec" {
  apikey = var.elastic_cloud_api_key
}