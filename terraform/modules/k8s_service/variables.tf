variable "namespace" {
  type     = string
  nullable = false
}

variable "name" {
  type     = string
  nullable = false
}

variable "image" {
  description = "Container image."
  type        = string
  nullable    = false
}

variable "container_port" {
  description = "Port the container is listening on."
  type        = number
  nullable    = false
}

variable "gateway" {
  description = "HTTP route gateway name."
  type        = string
  nullable    = false
}

variable "listeners" {
  description = "Gateway listener name (aka: sectionName)."
  type        = list(string)
  nullable    = false
}

variable "prefix" {
  description = "HTTP route path prefix."
}

variable "replicas" {
  description = "Number of replicas for the deployment."
  type        = number
  default     = 1
}

variable "env" {
  description = "Non-secret environment variables."
  type        = map(string)
  default     = {}
}

variable "secret_env_yaml_file" {
  description = "Path to a yaml file containing secret environment variables."
  type        = string
  default     = null
}

variable "secret_regcred_json_file" {
  description = "Path to a JSON file containing docker config credentials for image pulling."
  type        = string
  default     = null
}

variable "restart_on_apply" {
  description = "Restart pods on terraform apply (even if there are no changes)."
  type        = bool
  default     = false
}
