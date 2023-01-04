resource "aws_lb_listener_rule" "rule" {

  listener_arn       = var.listener_arn

  action {
    type             = var.action_type
    target_group_arn = var.target_group
  }

  condition {
    host_header {
      values = var.host_header
    }
  }
}
