resource "aws_lb_listener" "listener" {
  count = length(var.listener_ports)
  load_balancer_arn = var.load_balancer_arn
  port              = var.listener_ports[count.index]
  protocol          = var.protocol
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }

  depends_on = [aws_lb_target_group.http]
}

resource "aws_lb_target_group" "http" {
  name       = var.target_group_name
  port              = var.target_port
  protocol          = var.protocol
  vpc_id            = var.vpc_id

  # Use IP to support Fargate clusters
  target_type = "instance"

  health_check {
    protocol = var.health_protocol
    port     = var.health_port
  }
}

# Automatically attach autoscaling group to target group
resource "aws_autoscaling_attachment" "asg_attachment" {
  # count                  = var.autoattach_autoscaling_group ? 1 : 0
  autoscaling_group_name = var.autoscaling_group_name
  alb_target_group_arn    = aws_lb_target_group.http.arn
  depends_on = [
    aws_lb_target_group.http
  ]
}