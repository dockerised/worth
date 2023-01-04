variable "region" {
  default = "eu-west-2"
}

variable "environment" {
  default = "preprod"
}

variable "stack_region" {
  default = "eu-west-2"
}

variable "project_name" {
  type    = string
  default = null
}

variable "instance_class" {
  type        = string
  description = "RDS instance size eg. db.t4g.micro"
  default     = "db.t3.micro"
}


variable "eks_cluster_CIDR" {
  default = "10.36.0.0/16"
}

variable "namespace" {
  default = "default"
}

variable "docker_registry_password"{
}