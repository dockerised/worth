output "rules" {
  value = aws_lb_listener.listener[*]
}

output "arns" {
  value = aws_lb_listener.listener[*].arn
}

output "target_group_arn" {
  value = aws_lb_target_group.http.arn
}