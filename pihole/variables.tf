# PVE configuration
variable "pve_url" {
  type        = string
  description = "Get API URL for the PVE"
}
variable "pve_tls_insecure" {
  type        = string
  description = "Get the tls_insecure for authenticate with Proxmox"
}
variable "pve_token_id" {
  type        = string
  description = "Get the token id for authenticate with Proxmox"
}
variable "pve_token_secret" {
  type        = string
  description = "Get the token secret for authenticate with Proxmox"
}

# VM's properties
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
