variable "load_balancer_arn" {
  type = string
}
variable "vpc_id" {
  type = string
  default = ""
}

variable "listener_ports" {
  type = list(number)
  default = []
}

variable "target_port" {
  type = number
  default = 80
}

variable "health_port" {
  type = string
}
variable "health_protocol" {
  type = string
  default = "HTTP"
}

variable "protocol" {
  type = string
}
variable "target_group_name" {
  type = string
  default = ""
}

variable "type" {
  type = string
}

variable "ssl_policy" {
  type = string
  default = ""
}

variable "certificate_arn" {
  type = string
  default = ""
}

variable "redirect" {
  type = object({
    port        = string
    protocol    = string
    status_code = string
  })
  default = {
    port        = ""
    protocol    = ""
    status_code = ""
  }
}

variable "fixed_response" {
  type = object({
    content_type = string
    message_body = string
    status_code  = string
  })
  default = {
    content_type = ""
    message_body = ""
    status_code  = ""
  }
}

variable "autoattach_autoscaling_group" {
  type = bool
  default = false  
}
variable "autoscaling_group_name" {
  type = string
  default = null
}