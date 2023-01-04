#
# Provider Configuration
provider "aws" {
  region = var.region

}

provider "http" {}



terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
    aws = {
      source = "hashicorp/aws"
    }
    helm = {
      source = "hashicorp/helm"
    }
    http = {
      source = "hashicorp/http"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
  
}