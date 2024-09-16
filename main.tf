terraform {
  required_version = ">= 1.1.0"
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc4"  # Replace with the latest stable version
      # version = "2.9.14"  # Replace with the latest stable version
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://zeus.onemarc.io:8006/api2/json"
  # pm_user    = "root@pam"
  # pm_password = "hdesk666!"
  pm_api_token_id = "root@pam!mptd"
  pm_api_token_secret = "3b46b621-afe8-4ea2-87ae-1ef8526d4af7"
  pm_tls_insecure = true
}

variable "master_address" {
  type        = list(string)
  description = "The address of the master nodes"
}

variable "worker_address" {
  type        = list(string)
  description = "The address of the worker nodes"
}

resource "proxmox_vm_qemu" "new_vm" {
  name = "new-vm"
  desc = "Created from the ubuntu-server-24-04 template"

  target_node  = "zeus"
  pool         = "dev"
  clone        = "ubuntu-server-24-04"
  full_clone   = true

  agent    = 1

  os_type  = "ubuntu"
  cores    = 2
  sockets  = 1
  cpu      = "kvm64"	# if empty 'host' is default

  memory   = 2048
  balloon  = 1024

  # Set the boot disk paramters
  bootdisk = "virtio0"
  scsihw   = "virtio-scsi-pci"

  disks {
    virtio {
      virtio0 {
        disk {
          size    = 32
          cache   = "writeback"
          storage = "local-lvm"
        }
      }
    }
  } # end disk

  # Set the network
  network {
    model   = "virtio"
    bridge  = "vmbr0"
    macaddr = var.master_address[0]
  } # end first network block

  # Ignore changes to the network
  ## MAC address is generated on every apply, causing
  ## TF to think this needs to be rebuilt on every apply
  lifecycle {
    ignore_changes = [
      network
    ]
  } # end lifecycle

  # ipconfig0 = "ip=192.168.8.150/24,gw=192.168.8.1"

  # cicustom = <<-EOF
  # #cloud-config
  # network:
  #   version: 2
  #   ethernets:
  #     eth0:
  #       addresses:
  #         - 192.168.8.150/24
  #       gateway4: 192.168.8.1
  # EOF

}

output "disk_info" {
  value = proxmox_vm_qemu.new_vm.disks
}
