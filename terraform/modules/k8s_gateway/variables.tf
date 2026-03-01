variable "namespace" {
  description = "The namespace to deploy the gateway into"
  type        = string
  nullable    = false
}

variable "name" {
  description = "The name of the gateway"
  type        = string
  default     = "gateway"
}

variable "hostnames" {
  type     = list(string)
  nullable = false
}

variable "loadbalancer_name" {
  description = "The name of the loadbalancer created by the Gateway"
  type        = string
  default     = null
}

variable "loadbalancer_size" {
  type    = number
  default = 1
}
