# Variables Configuration

variable "cluster-name" {
  default     = "eks-cluster"
  type        = string
  description = "The name of your EKS Cluster"
}

variable "aws-region" {
  default     = "eu-west-2"
  type        = string
  description = "The AWS Region to deploy EKS"
}

variable "availability-zones" {
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
  type        = list
  description = "The AWS AZ to deploy EKS"
}

variable "k8s-version" {
  default     = "1.17"
  type        = string
  description = "Required K8s version"
}

variable "kublet-extra-args" {
  default     = ""
  type        = string
  description = "Additional arguments to supply to the node kubelet process"
}

variable "public-kublet-extra-args" {
  default     = ""
  type        = string
  description = "Additional arguments to supply to the public node kubelet process"

}

variable "vpc-subnet-cidr" {
  default     = "10.0.0.0/16"
  type        = string
  description = "The VPC Subnet CIDR"
}

variable "private-subnet-cidr" {
  default     = ["10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19"]
  type        = list
  description = "Private Subnet CIDR"
}

variable "public-subnet-cidr" {
  default     = ["10.0.128.0/20", "10.0.144.0/20", "10.0.160.0/20"]
  type        = list
  description = "Public Subnet CIDR"
}

variable "db-subnet-cidr" {
  default     = ["10.0.192.0/21", "10.0.200.0/21", "10.0.208.0/21"]
  type        = list
  description = "DB/Spare Subnet CIDR"
}

variable "eks-cw-logging" {
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  type        = list
  description = "Enable EKS CWL for EKS components"
}

variable "node-instance-type" {
  default     = "m4.large"
  type        = string
  description = "Worker Node EC2 instance type"
}

variable "root-block-size" {
  default     = "20"
  type        = string
  description = "Size of the root EBS block device"

}

variable "desired-capacity" {
  default     = 1
  type        = string
  description = "Autoscaling Desired node capacity"
}

variable "max-size" {
  default     = 1
  type        = string
  description = "Autoscaling maximum node capacity"
}

variable "min-size" {
  default     = 1
  type        = string
  description = "Autoscaling Minimum node capacity"
}

variable "ec2-key-public-key" {
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDlNQHV5VApZuneWtc9m9d7WEUqmfoLWm0John5vRwoPC0GYIU56BH90Yeiw5HkXJsiqnO+WXubFqWylhCRyfckNiTC7sKbpydZHVH4VmvNzOV4z8BXPob1qsnL2d+5eO8U7Sf21jpBQ4HEXgBk4GZ4eRuktM4eYRGsgTRW/FLFUex6c76Nb5va0FakDKXNKiojIoTIjLN0sxKAQtxuJAt4X4Jg6rtd5pS/4l9pH/VPncKcag1tDvx5ytN/4+lb9IZg/8OyG5JZDWaCsvhauJxn+LGP3GtHiEmiu3IMvTwthVWBj1rmFaX/KoOSlQazHlzEREHQ51mb+6MXSwoz+WrqcgkvFLtky0syMRqwjBgCU2IoKS/Cn2+qh7pI0L7ctPb7WjKmQw7vTfQDW3IDPPU2/H2WlJRChrLMWYzFt6oBWKDr4D7YwH89LYsA67rR9xZHY6TgmVexjiXPjnawAqHKEryESqSuNLDWQmNwrGJaWzmf04T3N+5puDIyuhq5MIlbP63mxSXOUEsFIsCKZPkuh/oR105cbSW3U2fZIajuNICXU/YETChn9K7CaR53uqWM7A6vU2VipNb8NJ4v0IP1djECR3/HwrCY+04Fvt/ZOzbvME6cXxfPZLCDRF9Styz4NiTKPQz/6g3Gbl6CF86vdG8uVKmLRUbSBUbEJX02Sw== george@cogitogroup.co.uk"
  type        = string
  description = "AWS EC2 public key data"
}

variable "region" {
  default = "eu-west-2"
}

variable "environment" {
  default = "prod"
}



variable "stack_region" {
  default = "eu-west-2"
}

variable "create_eks_cluster" {
  type = bool
  default = true
  description = "Defines whether or not the eks cluster is created"
}

variable "create_default_node_group" {
  type = bool
  default = true
  description = "Defines whether or not the default node group is created"
}
