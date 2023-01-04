# locals {
#   kubeconfig = <<KUBECONFIG

# apiVersion: v1
# clusters:
# - cluster:
#     server: ${aws_eks_cluster.eks.endpoint}
#     certificate-authority-data: ${aws_eks_cluster.eks.certificate_authority.0.data}
#   name: ${var.cluster-name}
# contexts:
# - context:
#     cluster: ${var.cluster-name}
#     user: ${var.cluster-name}
#   name: ${var.cluster-name}
# current-context: ${var.cluster-name}
# kind: Config
# preferences: {}
# users:
# - name: ${var.cluster-name}
#   user:
#     exec:
#       apiVersion: client.authentication.k8s.io/v1alpha1
#       command: aws
#       args:
#         - "eks"
#         - "get-token"
#         - "--cluster-name"
#         - "${var.cluster-name}"
#         - "--region"
#         - "${var.aws-region}"
# KUBECONFIG
# }

