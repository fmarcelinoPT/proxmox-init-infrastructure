terraform {
  required_version = ">= 1.1.0"
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc4" # Replace with the latest stable version
    }
  }
}

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

provider "proxmox" {
  pm_api_url          = var.pve_url
  pm_tls_insecure     = var.pve_tls_insecure
  pm_api_token_id     = var.pve_token_id
  pm_api_token_secret = var.pve_token_secret
}
