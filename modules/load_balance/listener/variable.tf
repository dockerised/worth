variable "load_balancer_arn" {
  type = string
}
variable "vpc_id" {
  type = string
  default = ""
}

variable "port" {
  type = string
}
variable "health_port" {
  type = string
}

variable "protocol" {
  type = string
}
variable "target_group_name_prefix" {
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
