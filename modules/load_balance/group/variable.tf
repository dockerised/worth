variable "name" {
  type = string
}

variable "port" {
  type = string
}

variable "protocol" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "target_type" {
  type = string
}

variable "health_check" {
  type = object({
    enabled             = bool
    interval            = number
    path                = string
    port                = string
    protocol            = string
    timeout             = string
    healthy_threshold   = string
    unhealthy_threshold = string
    matcher             = string
  })
}