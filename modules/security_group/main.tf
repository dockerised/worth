resource "aws_security_group" "sg" {
  vpc_id        = var.vpc_id
  name          = var.tags["Name"]
  
  tags = var.tags
}
