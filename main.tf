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

# Cloud Platform properties
variable "master_address" {
  type        = list(string)
  description = "The address of the master nodes"
}
variable "worker_address" {
  type        = list(string)
  description = "The address of the worker nodes"
}

# DON'T RUN FOR NOW ---- RUNNING OK FOR NOW
# module "pihole" {
#   source = "./pihole"
#   # Injecting PROVIDER variables
#   pve_tls_insecure     = var.pve_tls_insecure
#   pve_url              = var.pve_url
#   pve_token_id         = var.pve_token_id
#   pve_token_secret     = var.pve_token_secret
#   # Injecting SCRIPT variables
#   domain               = var.domain
#   cloud_init_username  = var.cloud_init_username
#   cloud_init_password  = var.cloud_init_password
#   cloud_init_sshkeys   = var.cloud_init_sshkeys
# }

module "cloud_platform" {
  source = "./cloud_platform"
  # Injecting PROVIDER variables
  pve_tls_insecure     = var.pve_tls_insecure
  pve_url              = var.pve_url
  pve_token_id         = var.pve_token_id
  pve_token_secret     = var.pve_token_secret
  # Injecting SCRIPT variables
  domain               = var.domain
  cloud_init_username  = var.cloud_init_username
  cloud_init_password  = var.cloud_init_password
  cloud_init_sshkeys   = var.cloud_init_sshkeys
  # cloud platform variables
  master_address       = var.master_address
  worker_address       = var.worker_address
}
