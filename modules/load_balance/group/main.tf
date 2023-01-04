resource "aws_lb_target_group" "lb_group" {
  
  name          = var.name
  port          = var.port
  protocol      = var.protocol
  vpc_id        = var.vpc_id
  target_type   = var.target_type
  
  health_check  {
    enabled             = var.health_check.enabled
    interval            = var.health_check.interval
    path                = var.health_check.path
    port                = var.health_check.port
    protocol            = var.health_check.protocol
    timeout             = var.health_check.timeout
    healthy_threshold   = var.health_check.healthy_threshold
    unhealthy_threshold = var.health_check.unhealthy_threshold
    matcher             = var.health_check.matcher
  }
}