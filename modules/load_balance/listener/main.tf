resource "aws_lb_listener" "listener" {
  load_balancer_arn = var.load_balancer_arn
  port              = var.port
  protocol          = var.protocol
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type = var.type

    dynamic "redirect" {
      for_each = var.type == "redirect" ? [1] : []
      content {
        port        = var.redirect.port
        protocol    = var.redirect.protocol
        status_code = var.redirect.status_code
      }
    }

    dynamic "fixed_response" {
      for_each = var.type == "fixed-response" ? [1] : []
      content {
        content_type = var.fixed_response.content_type
        message_body = var.fixed_response.message_body
        status_code  = var.fixed_response.status_code
      }
    }
    target_group_arn = var.type == "forward" ? aws_lb_target_group.http[0].arn : ""
  }

  depends_on = [aws_lb_target_group.http[0]]
}

resource "aws_lb_target_group" "http" {
  count            = var.type == "forward" ? 1 : 0
  name_prefix       = var.target_group_name_prefix
  # Forward to via HTTPS on port
  # protocol          = var.protocol
  # port               = var.port
  # Forward to via HTTP on port 30080 to direct to Nginx Ingress NodePort
  port               = "30080"
  protocol          = "HTTP"
  vpc_id      = var.vpc_id

  # Use IP to support Fargate clusters
  target_type = "instance"

  health_check {
    protocol = "HTTP"
    port     = var.health_port
  }
}