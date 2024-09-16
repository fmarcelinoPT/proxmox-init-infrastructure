terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.64.0" # x-release-please-version
    }
  }
}

# Configure the Proxmox provider
provider "bpg" {
  url     = "https://zeus.onemarc.io:8006/api2/json"
}

# Define the VM to create
resource "bpg_vm" "new_vm" {
  name        = "new_vm_name"
  node        = "zeus"
  storage     = "local-lvm"
  template_id = "1000" # Replace with the ID of the existing clone

  # Optional configuration for the new VM
  cores       = 2
  memory      = 2048
  ide0_disk   = {
    size = 10
  }
}