variable "target_node" {}
variable "target_storage" {}

# # Upload the RHEL QCOW2 image to Proxmox storage
# resource "proxmox_file" "rhel_qcow2" {
#   content_type = "iso"
#   datastore_id = "local"                 # Adjust to your storage name
#   node_name    = var.target_node         # Your Proxmox node name

#   source_file {
#     path      = "/home/fmarcelino/Downloads/rhel-10.0-x86_64-kvm.qcow2" # Local path or URL to RHEL QCOW2
#     file_name = "rhel-server.qcow2"      # Name it will be stored as
#   }
# }

# Create the RHEL VM
resource "proxmox_vm_qemu" "rhel_vm" {
  name         = "rhel-vm"
  vmid         = 111                      # Choose an available VM ID
  target_node  = var.target_node          # Your Proxmox node name

  desc         = "Red Hat Enterprise Linux VM"

  # CPU configuration
  cores   = 2
  sockets = 1
  cpu     = "host"
  numa    = true

  # Memory configuration
  memory = 4096
  balloon = 0  # Disable ballooning for RHEL

  # Setup the disk
  boot = "order=virtio0"
  scsihw = "virtio-scsi-pci"

  # Disk configuration using uploaded image
  disk {
    type    = "disk"
    storage = "local-lvm"
    size    = "30G"
    # format  = "qcow2"
    cache   = "writeback"
    slot    = "virtio0"
    # Reference the uploaded file
    disk_file = ""
  }

  # Network configuration
  network {
    model  = "virtio"
    bridge = "vmbr0"
    macaddr = "92:0A:34:32:C1:11"
  }

  # UEFI Boot (for RHEL 8+)
  bios       = "ovmf"
  efidisk {
    efitype = "4m"
    storage = "local-lvm"
  }

  # QEMU agent
  agent = 1

  # Serial console
  serial {
    id = 0
    type = "socket"
  }

  lifecycle {
    ignore_changes = [
      network,
      disk
    ]
  }
}

output "vm_ip" {
  value = proxmox_vm_qemu.rhel_vm.default_ipv4_address
}
