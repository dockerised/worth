locals {
  cluster_name           = "${var.environment}"
  cluster_address_prefix = "10.36"
}


# Provider configuration
provider "aws" {

  # version = "~> 2.22"
  region = var.stack_region
}


module "eks" {
  source = "./modules/eks-priv"

  aws-region          = var.stack_region
  availability-zones  = ["${var.stack_region}a", "${var.stack_region}b", "${var.stack_region}c"]
  cluster-name        = local.cluster_name
  k8s-version         = "1.22"
  node-instance-type  = "t3.medium"
  desired-capacity    = 2
  max-size            = 3
  min-size            = 1
  vpc-subnet-cidr     = "${local.cluster_address_prefix}.0.0/16"
  private-subnet-cidr = ["${local.cluster_address_prefix}.0.0/19", "${local.cluster_address_prefix}.32.0/19", "${local.cluster_address_prefix}.64.0/19"]
  public-subnet-cidr  = ["${local.cluster_address_prefix}.128.0/20", "${local.cluster_address_prefix}.144.0/20", "${local.cluster_address_prefix}.160.0/20"]
  db-subnet-cidr      = ["${local.cluster_address_prefix}.192.0/21", "${local.cluster_address_prefix}.200.0/21", "${local.cluster_address_prefix}.208.0/21"]
  eks-cw-logging      = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  ec2-key-public-key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC49iROO5a2msvzjmGyY5g7whQy0FbJpSicVx95VPNoHyQH/QQbnQt3zzD+EqSwpEFLqf2vQQZotaw1mgRNa3xnGdw//l4sKM8UDib+R76SH1HcCfaBCoVSgP07uKzA2/dGcOR/HtKZp8sg6HKyMLHErRxAg+Sz6cYs7GcH/rQhymRsnDtr30UH6SYKUVEqh6em6kC7ISHrsAIiZDJl7dKOUryJKpc4uddg7l4ibNQ3bFQbvcrYi/YvaCvEWNoYy9CgoCinIv0z4tjgbpo4dGA/ksqdVScGhgmKJ7JyLi4XxNApstE4PDM3CKm9oBzx83uB/ZvcC53JiKCmHn+tkuL63yh5KAG1qpjK0R6p2ND55YP8zDBIK/21jD/tyzS5VhiTI397GzVw+WqSrfhD6/+VJAzdDIBFF75Gs5bYCnCVyuxcMxuS3XnCSSV23JlSWWGQUXh5/0G1wPyKCC61Y9X7NtrImZhbK55+Eoi/gn5fFczu9c9fpCw0NaaKHJkyUDNLqZqDkEwxjuuvXFokICWY/MMS53ZS93f6aoSVKF77oUzfGdzEgbEliIQ9nOH3LhJfIwRChlpDNYRs8BZ7EhG5wsJhwpSbMuZXcm8OCr+2QOU9RVGazWo3xmoZ70s/RvVKlLVzvNrxXXBdyjrgADU359vmgDpDY8YnL43nZTmR6Q== georgec"
}

module "nlb" {
  source                     = "./modules/load_balance/load_balance"
  name                       = "${local.cluster_name}-nlb"
  internal                   = false
  load_balancer_type         = "network"
  security_groups            = null
  subnets                    = module.eks.public_subnets
  enable_deletion_protection = false
  # TODO: Access logs 
  depends_on = [
    module.eks
  ]
  tags = {
    Environment = var.environment
  }
}

module "nlb_listeners" {
  source                       = "./modules/load_balance/network-listeners"
  load_balancer_arn            = module.nlb.lb.arn
  listener_ports               = [80, 443]
  health_port                  = 30080
  health_protocol              = "HTTP"
  target_port                  = 30080
  type                         = "forward"
  protocol                     = "TCP"
  vpc_id                       = module.eks.vpc_id
  target_group_name            = "${local.cluster_name}-nlb-tg"
  autoattach_autoscaling_group = true
  autoscaling_group_name       = module.eks.node_autoscaling_group_name
  depends_on = [
    module.eks,
    module.nlb
  ]
}



# Application LoadBalabncer resources
module "alb_sg" {
  source = "./modules/security_group"
  vpc_id = module.eks.vpc_id
  tags = {
    Name        = "${local.cluster_name}-alb-sg"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# module "alb_sg_rule" {
#   source = "./modules/security_group/rule"
#   rule = {
#     type              = "ingress",
#     from_port         = "443",
#     to_port           = "443"
#     protocol          = "TCP"
#     cidr_blocks       = ["0.0.0.0/0"]
#     security_group_id = module.alb_sg.sec_group.id
#     description       = "Allow https ingress traffic"
#   }
# }

module "alb_sg_rule_http" {
  source = "./modules/security_group/rule"
  rule = {
    type              = "ingress",
    from_port         = "80",
    to_port           = "80"
    protocol          = "TCP"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = module.alb_sg.sec_group.id
    description       = "Allow http ingress traffic"
  }
}

# module "alb_sg_rule_egress" {
#   source = "./modules/security_group/rule"
#   rule = {
#     type              = "egress",
#     from_port         = "0",
#     to_port           = "0"
#     protocol          = "-1"
#     cidr_blocks       = ["0.0.0.0/0"]
#     security_group_id = module.alb_sg.sec_group.id
#     description       = "Allow all egress traffic"
#   }
# }


# module "alb" {
#   source                     = "./modules/load_balance/load_balance"
#   name                       = "${local.cluster_name}-alb"
#   enable_deletion_protection = false
#   subnets                    = module.eks.public_subnets
#   load_balancer_type         = "application"
#   security_groups            = [module.alb_sg.sec_group.id]
#   internal                   = false
#   tags = {
#     Name        = "${local.cluster_name}-alb"
#     Environment = var.environment
#     ManagedBy   = "terraform"
#   }
# }

# module "alb_listen_80" {
#   source            = "./modules/load_balance/listener"
#   load_balancer_arn = module.alb.lb.arn
#   port              = 80
#   health_port        = 30080
#   protocol          = "HTTP"
#   type              = "redirect"

#   redirect = {
#     port        = "443"
#     protocol    = "HTTPS"
#     status_code = "HTTP_301"
#   }
# }

# module "alb_listen_443" {
#   source                   = "./modules/load_balance/listener"
#   load_balancer_arn        = module.alb.lb.arn
#   port                     = 443
#   health_port              = 30080
#   type                     = "forward"
#   protocol                 = "HTTP"
#   vpc_id                   = module.eks.vpc_id
#   target_group_name_prefix = "ekspre"
  
#   # certificate_arn = "arn:aws:acm:eu-west-2:676359791502:certificate/f19096b2-e5f3-4dc1-acf8-f1e2b3550df2"
# }

# Nodeport Security Group rules for eks-cluster-sg
resource "aws_security_group_rule" "cluster_nodeport_sg_30443" {
  type              = "ingress"
  from_port         = 30443
  to_port           = 30443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.eks.cluster_primary_security_group_id
}

resource "aws_security_group_rule" "cluster_nodeport_sg_30080" {
  type              = "ingress"
  from_port         = 30080
  to_port           = 30080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.eks.cluster_primary_security_group_id
}


# Nodeport Security Group rules for node within eks cluster
resource "aws_security_group_rule" "node_nodeport_sg_30443" {
  type              = "ingress"
  from_port         = 30443
  to_port           = 30443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.eks.node_security_group_id
}

resource "aws_security_group_rule" "node_nodeport_sg_30080" {
  type              = "ingress"
  from_port         = 30080
  to_port           = 30080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.eks.node_security_group_id
}


resource "helm_release" "nginx" {
  chart      = "./charts/ingress-nginx"
  name       = "ingress-nginx"
  namespace  = var.namespace
  version    = "0.01"
  values = [
    file("./templates/ingress-values.yaml")
  ] 

}
provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "awsv2"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", "preprod"]
    }
  }
}

# Build and push the docker image
resource "docker_image" "worth" {
  name = "docker.io/george7522/worth"
  build {
    path = "."
    no_cache = true
    dockerfile = "./docker/Dockerfile"
    tag  = ["george7522/worth:latest"]
  }
}
resource "null_resource" "docker_push" {
  provisioner "local-exec" {
    command = "echo \"${var.docker_registry_password}\" | docker login -u george7222 --password-stdin ; docker push george7522/worth:latest"
  }
}