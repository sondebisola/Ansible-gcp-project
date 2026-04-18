
variable "gcp_project_id" {
  default = "enterpriseai-459922"
  type        = string
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