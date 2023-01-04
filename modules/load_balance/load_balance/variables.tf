variable "name" {
 type = string
}
variable "internal" {
 type = bool
}
variable "load_balancer_type" {
 type = string
}
variable "security_groups" {
 default= []
 type = list(string)
}
variable "subnets" {
 type = list(string)
}
variable "enable_deletion_protection" {
 type = bool
}
variable "tags" {
 type = any
 default= {}
}

variable "access_logs" {
  type = object({
    bucket  = string
    prefix  = string
    enabled = bool
  })
  default = {
    bucket  = ""
    prefix  = ""
    enabled = false
  }
}
