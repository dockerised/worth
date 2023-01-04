# BASTION
resource "aws_security_group" "remote_access" {
  name_prefix = "${local.name}-remote-access"
  description = "Allow remote SSH access"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block, "${trim(data.http.workstation-external-ip.response_body,"\n")}/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = local.tags
}

# Node Group Ingress
# resource "aws_security_group" "ingress" {
#   name = "${local.name}-node-sg"
#   description = "Allow load balancers access to nodes"
#   vpc_id      = module.vpc.vpc_id

#   ingress {
#     description = "ALB access"
#     from_port   = 30080
#     to_port     = 30080
#     protocol    = "TCP"
#     cidr_blocks = [module.vpc.vpc_cidr_block]
#   }
#   ingress {
#     description = "NLB access"
#     from_port   = 30443
#     to_port     = 30443
#     protocol    = "tcp"
#     cidr_blocks = [module.vpc.vpc_cidr_block]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   tags = local.tags
# }