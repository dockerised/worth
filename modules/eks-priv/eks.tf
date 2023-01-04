# provider "aws" {
#   region = local.region
# }

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_id]
  }
}


locals {
  name            = var.cluster-name
  cluster_version = var.k8s-version
  region          = var.aws-region

  tags = {
    environment = var.environment
    github_repo = "foundations"
    github_org  = "Commonplace-Digital-Ltd"
  }
}

data "aws_caller_identity" "current" {}

################################################################################
# EKS Module
################################################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.23.0"

  create = var.create_eks_cluster

  cluster_name                    = local.name
  cluster_version                 = local.cluster_version
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  # cluster_additional_security_group_ids = [ aws_security_group.remote_access.id ]

  cluster_ip_family = "ipv4"

  create_cni_ipv6_iam_policy = false

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts        = "OVERWRITE"
      service_account_role_arn = module.vpc_cni_irsa.iam_role_arn
    }
  }

  cluster_encryption_config = [{
    provider_key_arn = aws_kms_key.eks.arn
    resources        = ["secrets"]
  }]

  cluster_tags = {
    # This should not affect the name of the cluster primary security group
    # Ref: https://github.com/terraform-aws-modules/terraform-aws-eks/pull/2006
    # Ref: https://github.com/terraform-aws-modules/terraform-aws-eks/pull/2008
    Name = local.name
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Extend cluster security group rules
  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    },
    ingress_alb = {
      description      = "allow alb traffic"
      protocol          = "tcp"
      from_port         = 30080
      to_port           = 30080
      type              = "ingress"
      cidr_blocks      = [module.vpc.vpc_cidr_block]
    },
    ingress_nlb = {
      description      = "allow nlb traffic"
      protocol          = "tcp"
      from_port         = 30443
      to_port           = 30443
      type              = "ingress"
      cidr_blocks      = [module.vpc.vpc_cidr_block]
    }
  }

  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = [var.node-instance-type]

    # We are using the IRSA created below for permissions
    # However, we have to deploy with the policy attached FIRST (when creating a fresh cluster)
    # and then turn this off after the cluster/node group is created. Without this initial policy,
    # the VPC CNI fails to assign IPs and nodes cannot join the cluster
    # See https://github.com/aws/containers-roadmap/issues/1666 for more context
    iam_role_attach_cni_policy = true

  }

  tags = local.tags
}

module "mng-default" {
  source = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version = "18.23.0"

  create = true

  name            = "${var.cluster-name}-node"
  cluster_name    = module.eks.cluster_id
  cluster_version = module.eks.cluster_version

  create_launch_template = var.create_default_node_group
  launch_template_name   = "${var.cluster-name}-default-lc"

  instance_types = [var.node-instance-type]

  min_size     = var.min-size
  max_size     = var.max-size
  desired_size = var.desired-capacity

  vpc_id                            = module.vpc.vpc_id
  subnet_ids                        = module.vpc.private_subnets
  cluster_primary_security_group_id = module.eks.cluster_primary_security_group_id

  create_security_group = true
  security_group_name = "default-node-group-sg"
  security_group_description = "Security group for ${var.cluster-name} default eks managed node group"
  security_group_rules = [
    {
      type              = "ingress"
      protocol          = "TCP"
      from_port         = "30080"
      to_port           = "30080"
      description      = "allow alb traffic"
      cidr_blocks      = [module.vpc.vpc_cidr_block]
    },
    {
      type              = "ingress"
      protocol          = "TCP"
      from_port         = "30443"
      to_port           = "30443"
      description      = "allow nlb traffic"
      cidr_blocks      = [module.vpc.vpc_cidr_block]
    }
  ]

  # vpc_security_group_ids = [
  #   module.eks.cluster_security_group_id
  # ]

  tags = merge(local.tags, { Separate = "eks-managed-node-group" })
}

module "vpc_cni_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 4.12"

  role_name_prefix      = "VPC-CNI-IRSA"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv6   = false
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }

  tags = local.tags
}

resource "aws_kms_key" "eks" {
  description             = "EKS Secret Encryption Key"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = local.tags
}

resource "aws_kms_key" "ebs" {
  description             = "Customer managed key to encrypt EKS managed node group volumes"
  deletion_window_in_days = 7
  policy                  = data.aws_iam_policy_document.ebs.json
}