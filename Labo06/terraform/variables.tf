#  https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-variables
#  https://developer.hashicorp.com/terraform/language/values/variables

# Input variables let you customize aspects of Terraform modules without altering
# the module's own source code. This functionality allows you to share modules across
# different Terraform configurations, making your module composable and reusable.

variable "gcp_project_id" {
  description = "Project's ID in Google cloud"
  type        = string
  nullable    = false
}

variable "gcp_service_account_key_file_path" {
  description = "JSON Key file's path generated with Google Cloud"
  type        = string
  nullable    = false
}

variable "gce_instance_name" {
  description = "Name of VM instance"
  type        = string
  nullable    = false
}

variable "gce_instance_user" {
  description = "Name of used to log in with SSH"
  type        = string
  nullable    = false
}

variable "gce_ssh_pub_key_file_path" {
  description = "SSH key file's path used to log in as user"
  type        = string
  nullable    = false
}
