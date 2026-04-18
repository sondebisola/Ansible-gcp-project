# This replaces the AWS project/region logic
variable "gcp_project_id" {
  description = "Project ID for aif-usr-n-sonde-2273"
  type = string
}

variable "gcp_region" {
  type    = string
  default = "us-central1"
}


variable "my_key" {
  type    = string
  default = "~/.ssh/ansible-key.pub"
}

variable "my_instance_type" {
  type    = string
  default = "e2-medium"
}