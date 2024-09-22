resource "proxmox_vm_qemu" "pihole" {
  name        = "pihole.${var.domain}"
  vmid        = 200
  target_node = "zeus"
  pool        = "dev"

  # Clone from the same template
  clone      = "ubuntu-server-24-04"
  full_clone = true

  # Activate QEMU agent
  agent = 1

  os_type = "cloud-init"

  # Adjust cores, memory, and storage as needed
  cores   = 1
  sockets = 1
  cpu     = "kvm64"
  memory  = 1024
  balloon = 512

  scsihw = "virtio-scsi-pci"

  # Setup the disk
  boot = "order=virtio0"
  disks {
    ide {
      ide2 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          size     = 32
          cache    = "writeback"
          storage  = "local-lvm"
          iothread = true
          discard  = true
        }
      }
    }
  } # end setup Disks

  # Network interface
  network {
    model   = "virtio"
    bridge  = "vmbr0"
    macaddr = "92:0A:34:32:C0:13"
  }

  # Setup the ip address using cloud-init.
  # Keep in mind to use the CIDR notation for the ip.
  # ipconfig0 = "ip=dhcp"
  ipconfig0 = "ip=192.168.8.10/24,gw=192.168.8.1"
  nameserver = "8.8.8.8"

  # Use cloud-init for user and ssh keys
  ciuser     = var.cloud_init_username
  cipassword = var.cloud_init_password
  sshkeys    = var.cloud_init_sshkeys

  # You can configure additional resources here, like cloud-init scripts for PiHole installation
}
