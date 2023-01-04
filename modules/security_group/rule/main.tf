resource "aws_security_group_rule" "rule" {
  type                      = var.rule.type
  from_port                 = var.rule.from_port
  to_port                   = var.rule.to_port
  protocol                  = var.rule.protocol
  ipv6_cidr_blocks          = lookup(var.rule, "ipv6_cidr_blocks", null) 
  cidr_blocks               = lookup(var.rule, "cidr_blocks", null)
  source_security_group_id  = lookup(var.rule, "source_security_group_id", null)
  security_group_id         = var.rule.security_group_id # where to map the rule to
  description               = lookup(var.rule, "description", null) 
}