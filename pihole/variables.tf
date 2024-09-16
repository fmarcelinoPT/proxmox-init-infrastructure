variable "domain" {
  type        = string
  description = "Gets the domain to build the VM's FQDN"
}

variable "cloud_init_username" {
  type        = string
  description = "Username for cloud-init setup"
}
variable "cloud_init_password" {
  type        = string
  description = "Password for cloud-init setup"
}
variable "cloud_init_sshkeys" {
  type        = string
  description = "SSH Keys for cloud-init setup"
}
